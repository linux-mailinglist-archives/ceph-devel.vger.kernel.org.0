Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5CAD4528
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Oct 2019 18:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfJKQPY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 12:15:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbfJKQPY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Oct 2019 12:15:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF8C283F3D;
        Fri, 11 Oct 2019 16:15:23 +0000 (UTC)
Received: from [10.3.116.150] (ovpn-116-150.phx2.redhat.com [10.3.116.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D9AF60A9F;
        Fri, 11 Oct 2019 16:15:23 +0000 (UTC)
Subject: Re: local mode -- a new tier mode
To:     "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
From:   Mark Nelson <mnelson@redhat.com>
Message-ID: <555f9bd9-8523-02ab-d7b0-97cd860c4d71@redhat.com>
Date:   Fri, 11 Oct 2019 11:15:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 11 Oct 2019 16:15:23 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Honggang,


I personally I find this very exciting!  I was hoping that we might 
eventually try local caching in bluestore especially given trends for 
larger NVMe devices and pmem.  When you were running performance tests, 
did you run any tests where the data set size was significantly larger 
than the available "fast" local tier cache (ie so that eviction was 
taking place)?  In the past, that's been the area we've really needed to 
focus on getting right.


Mark


On 10/11/19 11:04 AM, Honggang(Joseph) Yang wrote:
> Hi,
>
> We implemented a new cache tier mode - local mode. In this mode, an
> osd is configured to manage two data devices, one is fast device, one
> is slow device. Hot objects are promoted from slow device to fast
> device, and demoted from fast device to slow device when they become
> cold.
>
> The introduction of tier local mode in detail is
> https://tracker.ceph.com/issues/42286
>
> tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-new
>
> This work is based on ceph v12.2.5. I'm glad to port it to master
> branch if needed.
>
> Any advice and suggestions will be greatly appreciated.
>
> thx,
>
> Yang Honggang
