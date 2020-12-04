Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813502CF50E
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Dec 2020 20:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgLDTun (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Dec 2020 14:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLDTun (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Dec 2020 14:50:43 -0500
Received: from smtp.bit.nl (smtp.bit.nl [IPv6:2001:7b8:3:5::25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1104C061A51
        for <ceph-devel@vger.kernel.org>; Fri,  4 Dec 2020 11:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=bit.nl;
        s=smtp01; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Cc;
        bh=rCzbLpu4a4/cMpVELGYLhbuuDVMz3nOans3poUXMeNE=; b=r0k7mGjPiq7FZuGs25aT0ZWBwV
        GNT6nVtWHZ1brQyFTjbg6SHaVWkh7IoM01q7jaTkebzz+9IYV+EXZv02o4CldRB0Ivj9LCW5mfu3x
        RYQSSelmUr4UKASfoRnxUxxBrs9CiOvXxM5rPlbORk2ZkHcxpga4wmP5aFdTKQWcIYiI65jwd5i8R
        LzOpvmnpT6wWu/SNG5+VMFca3Em467tZs8mc5/J5u9D1OVLASspsFT/a4puHD3GsX9TgK9JsKxgCr
        3Y1AaGGFwor4ZJkgbKUGGsXvuiJJEAWQXh9WrTtRzKMe6cL6XuMzwwz1DmueMY6Hnc1ntSedl33Z7
        g2QfxNBw==;
Received: from [2001:7b8:3:1002::1003] (port=7448)
        by smtp1.smtp.dmz.bit.nl with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stefan@bit.nl>)
        id 1klH5b-0006Fp-Op; Fri, 04 Dec 2020 20:49:59 +0100
To:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <9afdb763-4cf6-3477-bd32-762840c0c0a5@bit.nl>
 <ac5253d71ea50c8f5b4e50a07a1a0180abd58562.camel@kernel.org>
From:   Stefan Kooman <stefan@bit.nl>
Subject: Re: Investigate busy ceph-msgr worker thread
Message-ID: <945af793-1425-181a-c334-99e6602bc899@bit.nl>
Date:   Fri, 4 Dec 2020 20:49:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <ac5253d71ea50c8f5b4e50a07a1a0180abd58562.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 12/3/20 5:46 PM, Jeff Layton wrote:
> On Thu, 2020-12-03 at 12:01 +0100, Stefan Kooman wrote:
>> Hi,
>>
>> We have a cephfs linux kernel (5.4.0-53-generic) workload (rsync) that
>> seems to be limited by a single ceph-msgr thread (doing close to 100%
>> cpu). We would like to investigate what this thread is so busy with.
>> What would be the easiest way to do this? On a related note: what would
>> be the best way to scale cephfs client performance for a single process
>> (if at all possible)?
>>
>> Thanks for any pointers.
>>
> 
> Usually kernel profiling (a'la perf) is the way to go about this. You
> may want to consider trying more recent kernels and see if they fare any
> better. With a new enough MDS and kernel, you can try enabling async
> creates as well, and see whether that helps performance any.

The thread is mostly busy with "build_snap_context":


+   94.39%    94.23%  kworker/4:1-cep  [kernel.kallsyms]  [k] 
build_snap_context

Do I understand correctly if this code is checking for any potential 
snapshots? As grepping through linux cephfs code gives a hit on snap.c

Our cephfs filesystem has been created in Luminous, and upgraded through 
Mimic to Nautilus. We have never enabled snapshot support (ceph fs set 
cephfs allow_new_snaps true). But the filesystem does seem to support it 
(.snap dirs present). The data rsync is processing does contain a lot of 
directories. It might explain the amount of time spent in this code path.

Would this be a plausible explanation?

Thanks,

Stefan
