Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF613AD5
	for <lists+ceph-devel@lfdr.de>; Sat,  4 May 2019 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEDPNA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 4 May 2019 11:13:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:46405 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfEDPNA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 4 May 2019 11:13:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 08:12:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,430,1549958400"; 
   d="scan'208";a="148205380"
Received: from jerryopenix.sh.intel.com (HELO jerryopenix) ([10.239.158.74])
  by orsmga003.jf.intel.com with ESMTP; 04 May 2019 08:12:58 -0700
Date:   Sat, 4 May 2019 23:12:22 +0800
From:   "Liu, Changcheng" <changcheng.liu@intel.com>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
Message-ID: <20190504151222.GA18927@jerryopenix>
References: <20190416085820.GA4711@jerryopenix>
 <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix>
 <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
 <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
 <20190502014501.GA23390@jerryopenix>
 <57f21a5c314b743ee1de3196b830be6b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57f21a5c314b743ee1de3196b830be6b@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Penyaev,
   Below code shows where fork is called(ceph commit head: 878e488be3)
   File: src/ceph_osd.cc
        1 +--105 lines: -*- mode:C++; tab-width:8; c-basic-offset:2; indent-tabs-mode:t -*- ---
      106 int main(int argc, const char **argv)
      107 { 
      108 +-- 16 lines: vector<const char*> args;----------------------------------------------
      124   auto cct = global_init(      // call global_pre_init, then create call mc_bootstrap.get_monmap_and_config(). It'll create public messenger object
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      125     &defaults,
      126     args, CEPH_ENTITY_TYPE_OSD,
      127     CODE_ENVIRONMENT_DAEMON,
      128     0, "osd_data");
      129 +-- 65 lines: ceph_heap_profiler_init();---------------------------------------------
      194     int r = forker.prefork(err);
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ // fork child process
      195     if (r < 0) {
      196       cerr << err << std::endl;
      197       return r;
      198     }     
      199     if (forker.is_parent()) { //parent wait for child process to exit
      200 +--  9 lines: g_ceph_context->_log->start();-----------------------------------------
      209 +--326 lines: common_init_finish(g_ceph_context);------------------------------------
      535   Messenger *ms_public = Messenger::create(g_ceph_context, public_msg_type,
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^//in child process, it'll create the messenger object and query rdma device's attribute again.
      536                                            entity_name_t::OSD(whoami), "client",
      537                                            getpid(),
      538                                            Messenger::HAS_HEAVY_TRAFFIC |


   > That would be a perfect way, but I could not find an easy way to
   > destroy Infiniband singleton object (I did some experiments and
   > it turned out not so easy, e.g. if you can't deregister memory
   > regions in child process or after setuid()).
   [Changcheng]: In the desturction function DeviceList::~DeviceList(), we need a function to match with "rdma_get_devices". Or, the child process will still use the same fd opened by parent process and use the child process's crendential to operate the device(fd). The ib_uverbs.ko driver doesn't allow this kind of operation.

B.R.
Changcheng

On 10:36 Thu 02 May, Roman Penyaev wrote:
> On 2019-05-02 03:45, Liu, Changcheng wrote:
> > Hi Penyaev,
> >     Could you give more info about below point? I don't understand it
> > quiet well.
> >      > My question is why you daemonize your ceph services and do not
> > rely on systemd,
> >      > which does fork() on its own and runs each service with '-f'
> > flag, which means
> >      > do not daemonize?  So I would not daemonize services and this
> > can be a simple solution.
> 
> You provided the test, which reproduces the problem with -EACCESS,
> where you explicitly call fork().  According to my code understanding
> ceph services do fork() on early start only in daemon() glibc call
> (which internally does fork()).  If you use systemd daemonization
> is not used, so fork() is not called, so I am a bit confused: what
> exact places in the code you know, where fork() is called?
> 
> >     Thanks for your patch. I'll verify it when I'm back to office.
> >     Is it possible that rdma_cm library supply one API, e.g.
> > rdma_put_devices(), to close the devices in proper status?
> >     Then, the child process could re-open the device with
> > rdma_get_devices and query the device's attribute succeed.
> 
> That would be a perfect way, but I could not find an easy way to
> destroy Infiniband singleton object (I did some experiments and
> it turned out not so easy, e.g. if you can't deregister memory
> regions in child process or after setuid()).
> 
> --
> Roman
> 
