Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5E813657E
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 03:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgAJCli (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 21:41:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730886AbgAJCli (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jan 2020 21:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578624097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h11jVH0w5G0zgGPn/CiSyI4l2ycz3Qt1avOttlOx5j4=;
        b=GdqoMhbfLkpwsBiFtbZFQvCq55D7b4jKIIDICKhETskPlKr+TF24NGt9a4/QY5ywe+ZsOb
        9oBpD/a998R8IYfFymDpig28hl6A3as5PjuzzHwaaFpJGV/splghEZcej7z1OPU87sCig3
        49kU0tTThG4qroFdkOHWQLlRl4BwyaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-eHNgm4sROzS6PzHhp9_-Kw-1; Thu, 09 Jan 2020 21:41:35 -0500
X-MC-Unique: eHNgm4sROzS6PzHhp9_-Kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C77D01005512;
        Fri, 10 Jan 2020 02:41:34 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA815272A7;
        Fri, 10 Jan 2020 02:41:29 +0000 (UTC)
Subject: Re: [PATCH v2 1/8] ceph: add global dentry lease metric support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200108104152.28468-1-xiubli@redhat.com>
 <20200108104152.28468-2-xiubli@redhat.com>
 <d5e5040b7c177a6c8d66d8b68f4b965721693f85.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c9bd266d-36e4-5834-d38a-65fe807e7da3@redhat.com>
Date:   Fri, 10 Jan 2020 10:41:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <d5e5040b7c177a6c8d66d8b68f4b965721693f85.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/9 21:52, Jeff Layton wrote:
> On Wed, 2020-01-08 at 05:41 -0500, xiubli@redhat.com wrote:
[...]
>> @@ -1589,13 +1595,14 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>>   		}
>>   	}
>>   
>> +	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
>>   	if (!valid) {
>> -		struct ceph_mds_client *mdsc =
>> -			ceph_sb_to_client(dir->i_sb)->mdsc;
>>   		struct ceph_mds_request *req;
>>   		int op, err;
>>   		u32 mask;
>>   
>> +		percpu_counter_inc(&mdsc->metric.d_lease_mis);
>> +
>>   		if (flags & LOOKUP_RCU)
>>   			return -ECHILD;
>>   
> So suppose we're doing an RCU walk, and call d_revalidate and the dentry
> is invalid. We'll bump the counter here, but then return -ECHILD and the
> kernel will do the d_revalidate all over again with refwalk, and we bump
> the counter again.
>
> Won't that end up double-counting the cache miss? Or is that intended
> here?

Yeah, we should count it once. Will fix it in the next version.

Thanks,

