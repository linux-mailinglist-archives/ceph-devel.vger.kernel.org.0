Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791E614104
	for <lists+ceph-devel@lfdr.de>; Sun,  5 May 2019 18:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfEEQVv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 5 May 2019 12:21:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:43308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfEEQVv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 5 May 2019 12:21:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 24D6FAD31;
        Sun,  5 May 2019 16:21:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 05 May 2019 18:21:49 +0200
From:   Roman Penyaev <rpenyaev@suse.de>
To:     "Liu, Changcheng" <changcheng.liu@intel.com>
Cc:     ceph-devel@vger.kernel.org, ceph-devel-owner@vger.kernel.org
Subject: Re: Async Messenger RDMA IB ib_uverbs_write return EACCES
In-Reply-To: <20190504151222.GA18927@jerryopenix>
References: <20190416085820.GA4711@jerryopenix>
 <84005b8af680599e93f8bc3facbc00a3@suse.de>
 <20190416104119.GA6094@jerryopenix>
 <211951a560b75a8d13096c87f7a241c9@suse.de>
 <20190416120710.GA7940@jerryopenix> <20190419100628.GA15957@jerryopenix>
 <20190419143111.GA3102@jerryopenix>
 <7cf7c35992829e4e1b134d833dab1e0b@suse.de>
 <20190502014501.GA23390@jerryopenix>
 <57f21a5c314b743ee1de3196b830be6b@suse.de>
 <20190504151222.GA18927@jerryopenix>
Message-ID: <924ddc610814d52b61533ca604225fe8@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019-05-04 17:12, Liu, Changcheng wrote:
> Hi Penyaev,
>    Below code shows where fork is called(ceph commit head: 878e488be3)

This line corresponds to daemonazation.  Check global_init_prefork(),
if conf->daemonize  == false then error is returned and fork() is not
called.  So again I return to my question: why you do not want to leave
system tasks to systemd and invoke all ceph services with -f option?
What arch are you running on?

--
Roman
