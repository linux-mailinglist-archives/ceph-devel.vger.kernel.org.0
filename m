Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA7F3549C0
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Apr 2021 02:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhDFAn0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Apr 2021 20:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229615AbhDFAn0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Apr 2021 20:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617669798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sFVGdA2muXir6Auba6iQ3Kd65UfvVOmWhlCJAaqqGAs=;
        b=XZtLop9Nny3j8Raz1tv3Q5jC4o8g0OFoxrYGjs9yUyMLePziPBUsgB4IlKh5AEEzqnfn+n
        XFyEw2BbMgCvZnNPXQj+zsegipKUhfPwtv4YsjavEaSzNfrbRvOr6TYdrKnyORVsuGEW3x
        y5s5m8SOrdCbpZfAQz3DfaH8ghZ8KOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-1PB2Pj_fMPCVi2fFLW-NQw-1; Mon, 05 Apr 2021 20:43:16 -0400
X-MC-Unique: 1PB2Pj_fMPCVi2fFLW-NQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 522C11005D4F;
        Tue,  6 Apr 2021 00:43:15 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D10135F7D0;
        Tue,  6 Apr 2021 00:43:13 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix a typo in comments
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210329045904.135183-1-xiubli@redhat.com>
 <0d8435629047c4aa1820e51730273eb615a6aaa1.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7cdb5b39-9249-ce4e-a3ba-f780125f6846@redhat.com>
Date:   Tue, 6 Apr 2021 08:43:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <0d8435629047c4aa1820e51730273eb615a6aaa1.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/5 19:30, Jeff Layton wrote:
> On Mon, 2021-03-29 at 12:59 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/addr.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> index 57c67180ce5c..5b66f17afe0c 100644
>> --- a/fs/ceph/addr.c
>> +++ b/fs/ceph/addr.c
>> @@ -1945,7 +1945,7 @@ int ceph_pool_perm_check(struct inode *inode, int need)
>>   	if (ci->i_vino.snap != CEPH_NOSNAP) {
>>   		/*
>>   		 * Pool permission check needs to write to the first object.
>> -		 * But for snapshot, head of the first object may have alread
>> +		 * But for snapshot, head of the first object may have already
>>   		 * been deleted. Skip check to avoid creating orphan object.
>>   		 */
>>   		return 0;
> In general, I don't like to merge patches that just change comments
> without other substantive changes. I did make an exception in this
> patch:
>
>      [PATCH 1/2] ceph: fix kerneldoc copypasta over ceph_start_io_direct
>
> ...but that was mainly because that was generating a warning at build-
> time for me. I'm going to drop this patch for now.

Sure, will fix it in my next patch series.

Thanks

> Cheers,


