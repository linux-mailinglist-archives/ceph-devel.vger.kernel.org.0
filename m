Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7652F110FB
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 03:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfEBBpk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 May 2019 21:45:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:27149 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfEBBpk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 May 2019 21:45:40 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 May 2019 18:45:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,419,1549958400"; 
   d="scan'208";a="342644430"
Received: from jerryopenix.sh.intel.com (HELO jerryopenix) ([10.239.158.74])
  by fmsmga006.fm.intel.com with ESMTP; 01 May 2019 18:45:38 -0700
Date:   Thu, 2 May 2019 09:45:01 +0800
From:   "Liu, Changcheng" <changcheng.liu@intel.com>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
Message-ID: <20190502014501.GA23390@jerryopenix>
References: <20190415122240.GA7819@jerryopenix>
 <484935ae3aeb0ee6a59f93c3c727ba36@suse.de>
 <20190416085820.GA4711@jerryopenix>
 <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix>
 <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
 <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Penyaev,
    Could you give more info about below point? I don't understand it quiet well.
     > My question is why you daemonize your ceph services and do not rely on systemd,
     > which does fork() on its own and runs each service with '-f' flag, which means
     > do not daemonize?  So I would not daemonize services and this can be a simple solution.

    Thanks for your patch. I'll verify it when I'm back to office.
    Is it possible that rdma_cm library supply one API, e.g. rdma_put_devices(), to close the devices in proper status?
    Then, the child process could re-open the device with rdma_get_devices and query the device's attribute succeed.

    BTW, I'm on holiday during May-01~May-05. Email reply will be a little late. Thanks for your understanding.

B.R.
Changcheng 

On 18:40 Tue 30 Apr, Roman Penyaev wrote:
> On 2019-04-19 16:31, Liu, Changcheng wrote:
> > Hi Roman,
> >   I found that why ceph/msg/async/rdma/iwarp(x722) doesn't work on
> > ceph master branch.
> >   The problem is triggered by below commit:
> > 
> > https://github.com/ceph/ceph/pull/20172/commits/fdde016301ae329f76c621337c384ac60aa0d210
> > 
> >   Below is the basic program model extracted from
> > ceph/msg/async/rdma/iwarp to show how the problem is triggered:
> 
> Hi Changcheng,
> 
> Indeed fork() also changes credentials (see copy_creds() in kernel for
> details),
> like setuid() does, so there are two known places in ceph, after which
> uverbs
> calls return -EACESS:
> 
>   o setuid() (see global_init())
>   o daemon() (see global_init_daemonize())
> 
> My question is why you daemonize your ceph services and do not rely on
> systemd,
> which does fork() on its own and runs each service with '-f' flag, which
> means
> do not daemonize?  So I would not daemonize services and this can be a
> simple
> solution.
> 
> With setuid() is not that easy.  The most straightforward way is to move
> mc_bootstrap.get_monmap_and_config() after setuid() call.  At the bottom of
> the email there is a small patch which can fix the problem (I hope does not
> introduce something new). Would be great if you can check it.
> 
> --
> Roman
> 
> 
> diff --git a/src/global/global_init.cc b/src/global/global_init.cc
> index eb8bbfd1a4db..de647be768bd 100644
> --- a/src/global/global_init.cc
> +++ b/src/global/global_init.cc
> @@ -147,18 +147,6 @@ void global_pre_init(
>      cct->_log->start();
>    }
> 
> -  if (!conf->no_mon_config) {
> -    // make sure our mini-session gets legacy values
> -    conf.apply_changes(nullptr);
> -
> -    MonClient mc_bootstrap(g_ceph_context);
> -    if (mc_bootstrap.get_monmap_and_config() < 0) {
> -      cct->_log->flush();
> -      cerr << "failed to fetch mon config (--no-mon-config to skip)"
> -          << std::endl;
> -      _exit(1);
> -    }
> -  }
>    if (!cct->_log->is_started()) {
>      cct->_log->start();
>    }
> @@ -313,6 +301,28 @@ global_init(const std::map<std::string,std::string>
> *defaults,
>    }
>  #endif
> 
> +  //
> +  // Utterly important to run first network connection after setuid().
> +  // In case of rdma transport uverbs kernel module starts returning
> +  // -EACCESS on each operation if credentials has been changed, see
> +  // callers of ib_safe_file_access() for details.
> +  //
> +  // fork() syscall also matters, so daemonization won't work in case
> +  // of rdma.
> +  //
> +  if (!g_conf()->no_mon_config) {
> +    // make sure our mini-session gets legacy values
> +    g_conf().apply_changes(nullptr);
> +
> +    MonClient mc_bootstrap(g_ceph_context);
> +    if (mc_bootstrap.get_monmap_and_config() < 0) {
> +      g_ceph_context->_log->flush();
> +      cerr << "failed to fetch mon config (--no-mon-config to skip)"
> +          << std::endl;
> +      _exit(1);
> +    }
> +  }
> +
> 
> 
