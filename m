Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A88B1613ED
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 14:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgBQNuT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 08:50:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728091AbgBQNuT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Feb 2020 08:50:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581947418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OOgGLlM6qoWa6PQDDDdBhuT1UbdA6JK04bNF0zLRH0=;
        b=f0dvOQfxQiwYzYE62pQo2GIlLQbOFVbyLNOlAJ/TG5GnHIvhN0/ayWBn45yGQx2X04uOIr
        XilTVYfCriBaHuJGC5hOWEwxIqTFETzh90yIx6DDYH2cNB7oldKt9D1pIckCLtWhjJtLer
        8KG+wKj8LfEsdIpLEZpBVqM1Ly0pdzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-c1__28D6PHikzutVPOL73Q-1; Mon, 17 Feb 2020 08:50:17 -0500
X-MC-Unique: c1__28D6PHikzutVPOL73Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EAE9800D50;
        Mon, 17 Feb 2020 13:50:16 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4417D60BEC;
        Mon, 17 Feb 2020 13:50:09 +0000 (UTC)
Subject: Re: [PATCH v6 2/9] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200210053407.37237-1-xiubli@redhat.com>
 <20200210053407.37237-3-xiubli@redhat.com>
 <c4c0dc74b34e234bef78aca99c1e31e051c1c72d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1ef3bb02-a208-818d-dda6-84af8bf26f2d@redhat.com>
Date:   Mon, 17 Feb 2020 21:50:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <c4c0dc74b34e234bef78aca99c1e31e051c1c72d.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/17 21:27, Jeff Layton wrote:
> On Mon, 2020-02-10 at 00:34 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will fulfill the cap hit/mis metric stuff per-superblock,
>> it will count the hit/mis counters based each inode, and if one
>> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> caps          295             107             4119
>>
>> []
[...]
>>   
>> @@ -346,13 +346,16 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>>   	    ceph_snap(inode) != CEPH_SNAPDIR &&
>>   	    __ceph_dir_is_complete_ordered(ci) &&
>> -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
>> +	    (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
>>   		int shared_gen = atomic_read(&ci->i_shared_gen);
>> +		__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> Why is this dealing with Xs caps when you've checked Fs?

Good catch.

This might just copied from some where and forgot to change it. Will fix it.

>
>>   		spin_unlock(&ci->i_ceph_lock);
>>   		err = __dcache_readdir(file, ctx, shared_gen);
>>   		if (err != -EAGAIN)
>>   			return err;
>>   	} else {
>> +		if (ret != -1)
>> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> Ditto.

Here too.

Thanks.
Xiubo

