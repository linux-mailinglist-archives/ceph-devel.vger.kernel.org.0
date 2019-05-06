Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8214382
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 04:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfEFCVZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 5 May 2019 22:21:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:25213 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEFCVZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 5 May 2019 22:21:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 19:21:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="321760945"
Received: from jerryopenix.sh.intel.com (HELO jerryopenix) ([10.239.158.74])
  by orsmga005.jf.intel.com with ESMTP; 05 May 2019 19:21:24 -0700
Date:   Mon, 6 May 2019 10:20:48 +0800
From:   "Liu, Changcheng" <changcheng.liu@intel.com>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
Message-ID: <20190506022048.GA2877@jerryopenix>
References: <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix>
 <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
 <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
 <20190502014501.GA23390@jerryopenix>
 <57f21a5c314b743ee1de3196b830be6b@suse.de>
 <20190504151222.GA18927@jerryopenix>
 <924ddc610814d52b61533ca604225fe8@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924ddc610814d52b61533ca604225fe8@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 18:21 Sun 05 May, Roman Penyaev wrote:
> On 2019-05-04 17:12, Liu, Changcheng wrote:
> > Hi Penyaev,
> >    Below code shows where fork is called(ceph commit head: 878e488be3)
> 
> This line corresponds to daemonazation.  Check global_init_prefork(),
> if conf->daemonize  == false then error is returned and fork() is not
> called.  So again I return to my question: why you do not want to leave
> system tasks to systemd and invoke all ceph services with -f option?
> What arch are you running on?

I'm using ceph/src/vstart.sh to enable ceph/msg/async/rdma(iWARP) feature. The
default method of running ceph-osd daemon is without "-f" option.

I run ceph-osd daemon with "-f" option i.e. "vstart.sh --nodaemon", fork
operation is avoided and ceph/msg/async/rdma(iWARP) could work now.

> 
> --
> Roman
