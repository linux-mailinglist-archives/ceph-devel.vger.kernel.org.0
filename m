Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4786311585
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 10:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbfEBIgL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 May 2019 04:36:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:60924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfEBIgL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 May 2019 04:36:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA1B6ABE7;
        Thu,  2 May 2019 08:36:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 02 May 2019 10:36:09 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     "Liu, Changcheng" <changcheng.liu@intel.com>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
In-Reply-To: <20190502014501.GA23390@jerryopenix>
References: <20190415122240.GA7819@jerryopenix>
 <484935ae3aeb0ee6a59f93c3c727ba36@suse.de>
 <20190416085820.GA4711@jerryopenix>
 <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix> <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
 <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
 <20190502014501.GA23390@jerryopenix>
Message-ID: <57f21a5c314b743ee1de3196b830be6b@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019-05-02 03:45, Liu, Changcheng wrote:
> Hi Penyaev,
>     Could you give more info about below point? I don't understand it
> quiet well.
>      > My question is why you daemonize your ceph services and do not
> rely on systemd,
>      > which does fork() on its own and runs each service with '-f'
> flag, which means
>      > do not daemonize?  So I would not daemonize services and this
> can be a simple solution.

You provided the test, which reproduces the problem with -EACCESS,
where you explicitly call fork().  According to my code understanding
ceph services do fork() on early start only in daemon() glibc call
(which internally does fork()).  If you use systemd daemonization
is not used, so fork() is not called, so I am a bit confused: what
exact places in the code you know, where fork() is called?

>     Thanks for your patch. I'll verify it when I'm back to office.
>     Is it possible that rdma_cm library supply one API, e.g.
> rdma_put_devices(), to close the devices in proper status?
>     Then, the child process could re-open the device with
> rdma_get_devices and query the device's attribute succeed.

That would be a perfect way, but I could not find an easy way to
destroy Infiniband singleton object (I did some experiments and
it turned out not so easy, e.g. if you can't deregister memory
regions in child process or after setuid()).

--
Roman

