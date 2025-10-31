# made by Alexey Ershov https://github.com/chilipizdrick
{
  writeShellScriptBin,
  pipewire,
  jq,
  ...
}:
writeShellScriptBin "hijacker-lite" ''
  set -e

  function run() {
      pw_dump_output=$(${pipewire}/bin/pw-dump)

      query='.[] | select(.type == "PipeWire:Interface:Metadata" and .props."metadata.name" == "default") | .metadata[] | select(.key == "default.audio.source") | .value.name'
      default_sink=$(echo $pw_dump_output | ${jq}/bin/jq -rc "$query")

      echo "Found default sink: $default_sink"

      query=".[] | select(.type == \"PipeWire:Interface:Node\" and .info.props.\"node.name\" == \"''${default_sink}\") | .id"
      default_sink_node_id=$(echo $pw_dump_output | ${jq}/bin/jq -rc "$query")

      echo "Found default sink node id: $default_sink_node_id"

      query=".[] | select(.type == \"PipeWire:Interface:Link\" and .info.\"output-node-id\" == ''${default_sink_node_id}) | [.info.\"input-node-id\", .info.\"input-port-id\"]"
      link_info_pairs=$(echo $pw_dump_output | ${jq}/bin/jq -rc "$query")

      input_node_ids=()
      input_port_ids=()
      for p in "''${link_info_pairs[@]}"; do
          input_node_ids+=($(echo $p | ${jq}/bin/jq -r '.[0]'))
          input_port_ids+=($(echo $p | ${jq}/bin/jq -r '.[1]'))
      done

      echo "Found node ids connected to default sink output port:    ''${input_node_ids[@]}"
      echo "Found input ports connected to default sink output port: ''${input_port_ids[@]}"

      uid=$(shuf -i 0-65535 -n 1)
      ${pipewire}/bin/pw-play $1 --properties hijacker.uid=$uid &
      PLAYER_PID=$!

      for i in {1..10}; do
          sleep 0.1
          pw_dump_output=$(${pipewire}/bin/pw-dump)

          query=".[] | select(.type == \"PipeWire:Interface:Node\" and .info.props.\"hijacker.uid\" == ''${uid}) | .id"
          player_node_id=$(echo $pw_dump_output | ${jq}/bin/jq -r "$query")

          query="[.[] | select(.type == \"PipeWire:Interface:Port\" and .info.props.\"node.id\" == ''${player_node_id}) | .id] | .[0]"
          player_output_port_id=$(echo $pw_dump_output | ${jq}/bin/jq -r "$query")

          if [[ -n $player_node_id ]]; then
              break
          fi
      done

      if [[ -z $player_node_id ]]; then
          echo "Player node id not found"
          exit 1
      fi

      echo "Started playing file $1 with random player id $uid"
      echo "Found player node id: $player_node_id"
      echo "Found player output port id: $player_output_port_id"

      let end=''${#input_node_ids[@]}-1
      for i in $(seq 0 $end); do
          ${pipewire}/bin/pw-link -L $player_output_port_id ''${input_port_ids[$i]}
      done

      wait $PLAYER_PID
  }

  if [[ -z $1 ]]; then
      echo "Usage: $0 <file>"
      exit 1
  fi

  if [[ $1 == "--help" || $1 == "-h" ]]; then
      echo "Usage: $0 <file>"
      exit 0
  fi

  run "$@"
''
