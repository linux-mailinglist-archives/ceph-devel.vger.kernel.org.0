Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 502E13485F8
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Mar 2021 01:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhCYAnb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 20:43:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232170AbhCYAnC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 20:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616632981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wgYB37+IBpF1tEvrClHSL5UBINpSv+s23h7a77ZuDM=;
        b=FINKMk0ya08+M3EXKpQCvi3eFDZBgBqBVBacpunIBuJfcjB08CUveNbreKQXGJ35UlEu11
        9mjS/QH0vHow44CDJHJ+ib5IwdTHpUmlTUPfgI7cvVxIGRWLSbyefLCDw7wnNDKnBE+fzU
        8a1Sfgn0Jk3P/kL9d8p6SbsFPhjkDIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-BaiKAS_FO4Scyrrtk0Fbvg-1; Wed, 24 Mar 2021 20:42:59 -0400
X-MC-Unique: BaiKAS_FO4Scyrrtk0Fbvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAF87107B004;
        Thu, 25 Mar 2021 00:42:58 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E2E65B4B0;
        Thu, 25 Mar 2021 00:42:56 +0000 (UTC)
Subject: Re: [PATCH 0/4] ceph: add IO size metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210322122852.322927-1-xiubli@redhat.com>
 <7c17357ce0b7e9671c133aa1ed3c413b6a100407.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3f271f89-5cd0-a878-97ff-e3d9696cdf44@redhat.com>
Date:   Thu, 25 Mar 2021 08:42:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <7c17357ce0b7e9671c133aa1ed3c413b6a100407.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/24 23:06, Jeff Layton wrote:
> On Mon, 2021-03-22 at 20:28 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Currently it will show as the following:
>>
>> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
>> ----------------------------------------------------------------------------------------
>> read          1           10240           10240           10240           10240
>> write         1           10240           10240           10240           10240
>>
>>
>>
>> Xiubo Li (4):
>>    ceph: rename the metric helpers
>>    ceph: update the __update_latency helper
>>    ceph: avoid count the same request twice or more
>>    ceph: add IO size metrics support
>>
>>   fs/ceph/addr.c       |  20 +++----
>>   fs/ceph/debugfs.c    |  49 +++++++++++++----
>>   fs/ceph/file.c       |  47 ++++++++--------
>>   fs/ceph/mds_client.c |   2 +-
>>   fs/ceph/metric.c     | 126 ++++++++++++++++++++++++++++++++-----------
>>   fs/ceph/metric.h     |  22 +++++---
>>   6 files changed, 184 insertions(+), 82 deletions(-)
>>
> I've gone ahead and merged patches 1 and 3 from this series into
> ceph-client/testing. 1 was just a trivial renaming that we might as well
> get out of the way, and 3 looked like a (minor) bugfix. The other two
> still need a bit of work (but nothing major).

Sure, will fix them and post the v2 later.

Thanks Jeff.


> Cheers,


