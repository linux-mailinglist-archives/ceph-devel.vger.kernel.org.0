Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E0223C02
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 15:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgGQNMs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 09:12:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726201AbgGQNMs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jul 2020 09:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594991566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIIJYHd5yYm9zZgEiKgs1s1JoylY59QjCTwqvR29t90=;
        b=ckJLI9Uox+yPfO0EoSb8mL6YLTrl/iWU7pW6WCbV19UPW78mmoNCRq3hPa8p13Jo3BDYdf
        ernJL4g1Q1XJp0ex4vxJvCQy/2avMta8xeOhE9XfGZLDnAczyclv6Mjfs/qGrlJ3segKO1
        smcDcmpS8YwlaH1L31+28V6SvkDZIjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-FXSEPfTbMkWzgWC5SIDBRw-1; Fri, 17 Jul 2020 09:12:42 -0400
X-MC-Unique: FXSEPfTbMkWzgWC5SIDBRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3C319253C0;
        Fri, 17 Jul 2020 13:12:41 +0000 (UTC)
Received: from [10.72.12.127] (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A17F410013C4;
        Fri, 17 Jul 2020 13:12:38 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] ceph: send client provided metric flags in client
 metadata
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com
References: <20200716140558.5185-1-xiubli@redhat.com>
 <20200716140558.5185-3-xiubli@redhat.com>
 <a41b163828ee08ba3ec3986057115ba19c1d17b8.camel@kernel.org>
 <e7a61b3eca43cc3e3d96d4300c316245113decd4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <77770691-1323-7111-2cc5-d1fe1be42194@redhat.com>
Date:   Fri, 17 Jul 2020 21:12:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e7a61b3eca43cc3e3d96d4300c316245113decd4.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/17 20:07, Jeff Layton wrote:
> On Fri, 2020-07-17 at 07:26 -0400, Jeff Layton wrote:
>> On Thu, 2020-07-16 at 10:05 -0400, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Will send the metric flags to MDS, currently it supports the cap,
>>> read latency, write latency and metadata latency.
>>>
>>> URL: https://tracker.ceph.com/issues/43435
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   fs/ceph/mds_client.c | 60 ++++++++++++++++++++++++++++++++++++++++++--
>>>   fs/ceph/metric.h     | 13 ++++++++++
>>>   2 files changed, 71 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index cf4c2ba2311f..929778625ea5 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -1194,6 +1194,48 @@ static int encode_supported_features(void **p, void *end)
>>>   	return 0;
>>>   }
>>>   
>>> +static const unsigned char metric_bits[] = CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED;
>>> +#define METRIC_BYTES(cnt) (DIV_ROUND_UP((size_t)metric_bits[cnt - 1] + 1, 64) * 8)
>>> +static int encode_metric_spec(void **p, void *end)
>>> +{
>>> +	static const size_t count = ARRAY_SIZE(metric_bits);
>>> +
>>> +	/* header */
>>> +	if (WARN_ON_ONCE(*p + 2 > end))
>>> +		return -ERANGE;
>>> +
>>> +	ceph_encode_8(p, 1); /* version */
>>> +	ceph_encode_8(p, 1); /* compat */
>>> +
>>> +	if (count > 0) {
>>> +		size_t i;
>>> +		size_t size = METRIC_BYTES(count);
>>> +
>>> +		if (WARN_ON_ONCE(*p + 4 + 4 + size > end))
>>> +			return -ERANGE;
>>> +
>>> +		/* metric spec info length */
>>> +		ceph_encode_32(p, 4 + size);
>>> +
>>> +		/* metric spec */
>>> +		ceph_encode_32(p, size);
>>> +		memset(*p, 0, size);
>>> +		for (i = 0; i < count; i++)
>>> +			((unsigned char *)(*p))[i / 8] |= BIT(metric_bits[i] % 8);
>>> +		*p += size;
>>> +	} else {
>>> +		if (WARN_ON_ONCE(*p + 4 + 4 > end))
>>> +			return -ERANGE;
>>> +
>>> +		/* metric spec info length */
>>> +		ceph_encode_32(p, 4);
>>> +		/* metric spec */
>>> +		ceph_encode_32(p, 0);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>   /*
>>>    * session message, specialization for CEPH_SESSION_REQUEST_OPEN
>>>    * to include additional client metadata fields.
>>> @@ -1234,6 +1276,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>>   		size = FEATURE_BYTES(count);
>>>   	extra_bytes += 4 + size;
>>>   
>>> +	/* metric spec */
>>> +	size = 0;
>>> +	count = ARRAY_SIZE(metric_bits);
>>> +	if (count > 0)
>>> +		size = METRIC_BYTES(count);
>>> +	extra_bytes += 2 + 4 + 4 + size;
>>> +
>>>   	/* Allocate the message */
>>>   	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
>>>   			   GFP_NOFS, false);
>>> @@ -1252,9 +1301,9 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>>   	 * Serialize client metadata into waiting buffer space, using
>>>   	 * the format that userspace expects for map<string, string>
>>>   	 *
>>> -	 * ClientSession messages with metadata are v3
>>> +	 * ClientSession messages with metadata are v4
>>>   	 */
>>> -	msg->hdr.version = cpu_to_le16(3);
>>> +	msg->hdr.version = cpu_to_le16(4);
>>>   	msg->hdr.compat_version = cpu_to_le16(1);
>>>   
>>>   	/* The write pointer, following the session_head structure */
>>> @@ -1283,6 +1332,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>>   		return ERR_PTR(ret);
>>>   	}
>>>   
>>> +	ret = encode_metric_spec(&p, end);
>>> +	if (ret) {
>>> +		pr_err("encode_metric_spec failed!\n");
>>> +		ceph_msg_put(msg);
>>> +		return ERR_PTR(ret);
>>> +	}
>>> +
>>>   	msg->front.iov_len = p - msg->front.iov_base;
>>>   	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
>>>   
>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>> index fe5d07d2e63a..1d0959d669d7 100644
>>> --- a/fs/ceph/metric.h
>>> +++ b/fs/ceph/metric.h
>>> @@ -18,6 +18,19 @@ enum ceph_metric_type {
>>>   	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
>>>   };
>>>   
>>> +/*
>>> + * This will always have the highest metric bit value
>>> + * as the last element of the array.
>>> + */
>>> +#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
>>> +	CLIENT_METRIC_TYPE_CAP_INFO,		\
>>> +	CLIENT_METRIC_TYPE_READ_LATENCY,	\
>>> +	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
>>> +	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
>>> +						\
>>> +	CLIENT_METRIC_TYPE_MAX,			\
>> Not a huge problem now, but shouldn't this last line be?
>>
>> 	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_METADATA_LATENCY,
>>
>>
> Disregard my earlier mail here. I read this as if you were adding
> another enum. This patch looks fine.

Yeah, right. This will be like the FEATURE bits do before as we did.

Thanks

>>> +}
>>> +
>>>   /* metric caps header */
>>>   struct ceph_metric_cap {
>>>   	__le32 type;     /* ceph metric type */


