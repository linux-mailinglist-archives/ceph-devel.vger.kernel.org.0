Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF527550
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 07:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfEWFII (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 01:08:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:1957 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEWFIH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 01:08:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 22:08:07 -0700
X-ExtLoop1: 1
Received: from jerryopenix.sh.intel.com (HELO jerryopenix) ([10.239.158.171])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2019 22:08:04 -0700
Date:   Thu, 23 May 2019 13:07:00 +0800
From:   "Liu, Changcheng" <changcheng.liu@intel.com>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: msg/async/rdma: out of buffer/memory
Message-ID: <20190523050700.GA5492@jerryopenix>
References: <20190521095041.GA17062@jerryopenix>
 <244898c96f522d99a180a7477b75a5bc@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <244898c96f522d99a180a7477b75a5bc@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Roman,
   I'll check it and feedback to you later. (Something wrong with
   servers, I have to fix it first)

B.R.
Changcheng

On 12:04 Wed 22 May, Roman Penyaev wrote:
> On 2019-05-21 11:50, Liu, Changcheng wrote:
> > Hi all,
> >     I'm using msg/async/rdma/iWARP on ceph master branch under
> > vstart.sh environment.
> > 
> >     It hit "out of buffer/memory" frequently and hit segmental fault
> > sometimes.
> >     Does anyone know are there some configuration need to be tuned to
> > make it work?
> 
> I suppose 'ms_async_rdma_receive_buffers = 32768'.
> 
> Looks like rx buffers leak, i.e. when read request is completed
> chunk should be posted back to the pool, but seems that does not
> happen.  If you hit that often - can you debug and simply printf()
> the memory manager counter of current allocated chunks from pool?
> I suppose you should see counter growing.
> 
> --
> Roman
> 
> > 
> > 	1. Log:
> >          -49> 2019-05-21 17:37:50.729 7f843334a700 -1 Infiniband
> > post_chunks_to_rq WARNING: out of memory. Requested 1 rx buffers. Got
> > 0
> >          -48> 2019-05-21 17:37:50.729 7f843334a700 -1 Infiniband
> > can_alloc WARNING: OUT OF RX BUFFERS: allocated: 32768 requested: 4
> > limit: 32768
> >          -47> 2019-05-21 17:37:50.729 7f843334a700 -1 Infiniband
> > post_chunks_to_rq WARNING: out of memory. Requested 1 rx buffers. Got
> > 0
> >          -46> 2019-05-21 17:37:50.729 7f84381e5700 -1 Infiniband
> > can_alloc WARNING: OUT OF RX BUFFERS: allocated: 32768 requested: 4
> > limit: 32768
> >          -45> 2019-05-21 17:37:50.729 7f84381e5700 -1 Infiniband
> > post_chunks_to_rq WARNING: out of memory. Requested 3 rx buffers. Got
> > 1
> >          -1> 2019-05-21 17:37:53.269 7f84381e5700 -1
> > /home/nstcc1/ssg_otc/ceph_debian/ceph/src/msg/async/rdma/Infiniband.cc:
> >               In function 'int Infiniband::post_chunks_to_rq(int,
> > ibv_qp*)' thread 7f84381e5700 time 2019-05-21 17:37:53.241614
> > 
> > /home/nstcc1/ssg_otc/ceph_debian/ceph/src/msg/async/rdma/Infiniband.cc:
> > 1056: FAILED ceph_assert(ret == 0)
> >          ceph version v15.0.0-1316-gde22905799
> > (de2290579985e48fb61f6ab2f4f2245e1a699bf4) octopus (dev)
> >          1: (ceph::__ceph_assert_fail(char const*, char const*, int,
> > char const*)+0x1aa) [0x7f843f8dbd2a]
> >          2: (()+0x13a1fac) [0x7f843f8dbfac]
> >          3: (Infiniband::post_chunks_to_rq(int, ibv_qp*)+0x4b4)
> > [0x7f843fc623e4]
> >          4: (RDMADispatcher::post_chunks_to_rq(int, ibv_qp*)+0x62)
> > [0x7f843fc76e6a]
> >          5: (RDMAConnectedSocketImpl::update_post_backlog()+0x57)
> > [0x7f843fc6c395]
> >          6: (RDMAConnectedSocketImpl::read(char*, unsigned
> > long)+0xc42) [0x7f843fc69564]
> >          7: (ConnectedSocket::read(char*, unsigned long)+0x37)
> > [0x7f843fbc1549]
> > 
> >     2. ceph config:
> >         diff --git a/src/vstart.sh b/src/vstart.sh
> >         index eb17208b82..b70c78abfd 100755
> >         --- a/src/vstart.sh
> >         +++ b/src/vstart.sh
> >         @@ -547,6 +547,14 @@ ms bind msgr1 = true
> >                 osd_crush_chooseleaf_type = 0
> >                 debug asok assert abort = true
> >          $msgr_conf
> >         +
> >         +;set type & device & protocal iwarp(iWARP/RoCEv2) based on
> > rdma_cm instead of using GID
> >         +    ms_type = async+rdma
> >         +    ms_async_rdma_device_name = itest0
> >         +    ms_async_rdma_type = iwarp
> >         +    ms_async_rdma_support_srq = false
> >         +    ms_async_rdma_cm = true
> >         +
> >          $extra_conf
> >          EOF
> >                 if [ "$lockdep" -eq 1 ] ; then
> > 
> >      3. vstart.sh command:
> >        OSD=3 MON=1 MDS=0 RGW=0 MGR=1 ../src/vstart.sh --msgr1
> > --nodaemon -i 192.0.2.97 -n -X -d 2>&1 | tee check_log
> >        #192.0.2.97 is itest0's NIC ip address
> > 
> >      4. Part of default configuration
> >         bin/ceph-conf -D | grep ms_async
> >           ms_async_max_op_threads = 5
> >           ms_async_op_threads = 3
> >           ms_async_rdma_buffer_size = 131072
> >           ms_async_rdma_cm = true
> >           ms_async_rdma_device_name = itest0
> >           ms_async_rdma_dscp = 96
> >           ms_async_rdma_enable_hugepage = false
> >           ms_async_rdma_local_gid =
> >           ms_async_rdma_polling_us = 1000
> >           ms_async_rdma_port_num = 1
> >           ms_async_rdma_receive_buffers = 32768
> >           ms_async_rdma_receive_queue_len = 4096
> >           ms_async_rdma_roce_ver = 1
> >           ms_async_rdma_send_buffers = 1024
> >           ms_async_rdma_sl = 3
> >           ms_async_rdma_support_srq = false
> >           ms_async_rdma_type = iwarp
> > 
> >      5. itest0 device's attr
> >          hca_id: itest0
> >              transport:          iWARP (1)
> >              fw_ver:             29.0
> >              node_guid:          6805:ca9d:3898:0000
> >              sys_image_guid:         6805:ca9d:3898:0000
> >              hw_ver:             0x0
> >              board_id:           ITEST Board ID
> >              phys_port_cnt:          1
> >              max_mr_size:            0x7fffffff
> >              page_size_cap:          0x0
> >              max_qp:             16384
> >              max_qp_wr:          4095
> >              device_cap_flags:       0x00228000
> >                              MEM_WINDOW
> >                              MEM_MGT_EXTENSIONS
> >                              Unknown flags: 0x8000
> >              max_sge:            13
> >              max_sge_rd:         13
> >              max_cq:             32768
> >              max_cqe:            1048575
> >              max_mr:             4194303
> >              max_pd:             262144
> >              max_qp_rd_atom:         127
> >              max_ee_rd_atom:         0
> >              max_res_rd_atom:        0
> >              max_qp_init_rd_atom:        127
> >              max_ee_init_rd_atom:        0
> >              atomic_cap:         ATOMIC_NONE (0)
> >              max_ee:             0
> >              max_rdd:            0
> >              max_mw:             4194303
> >              max_raw_ipv6_qp:        0
> >              max_raw_ethy_qp:        0
> >              max_mcast_grp:          16384
> >              max_mcast_qp_attach:        8
> >              max_total_mcast_qp_attach:  131072
> >              max_ah:             65536
> >              max_fmr:            0
> >              max_srq:            0
> >              max_pkeys:          0
> >              local_ca_ack_delay:     0
> >              general_odp_caps:
> >              rc_odp_caps:
> >                              NO SUPPORT
> >              uc_odp_caps:
> >                              NO SUPPORT
> >              ud_odp_caps:
> >                              NO SUPPORT
> >              completion_timestamp_mask not supported
> >              core clock not supported
> >              device_cap_flags_ex:        0x0
> >              tso_caps:
> >              max_tso:            0
> >              rss_caps:
> >                  max_rwq_indirection_tables:         0
> >                  max_rwq_indirection_table_size:     0
> >                  rx_hash_function:                   0x0
> >                  rx_hash_fields_mask:                0x0
> >              max_wq_type_rq:         0
> >              packet_pacing_caps:
> >                  qp_rate_limit_min:  0kbps
> >                  qp_rate_limit_max:  0kbps
> >              tag matching not supported
> >                  port:   1
> >                      state:          PORT_ACTIVE (4)
> >                      max_mtu:        4096 (5)
> >                      active_mtu:     1024 (3)
> >                      sm_lid:         0
> >                      port_lid:       1
> >                      port_lmc:       0x00
> >                      link_layer:     Ethernet
> >                      max_msg_sz:     0x7fffffff
> >                      port_cap_flags:     0x00050000
> >                      port_cap_flags2:    0x0000
> >                      max_vl_num:     invalid value (0)
> >                      bad_pkey_cntr:      0x0
> >                      qkey_viol_cntr:     0x0
> >                      sm_sl:          0
> >                      pkey_tbl_len:       1
> >                      gid_tbl_len:        1
> >                      subnet_timeout:     0
> >                      init_type_reply:    0
> > 
> > B.R.
> > Changcheng
> 
