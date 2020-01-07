Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA9131DC2
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jan 2020 03:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgAGCuJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 21:50:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34441 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727295AbgAGCuJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jan 2020 21:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578365407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDuRs7+F9JNMAGnk4Bd/hSSlXTJCftGIp1dYmBZOyeg=;
        b=iAXGmZ2upDY6M85UhcwCfKFHuYqTQLyMyvx9WT4gSi259BFx3T/NpwwgeBTroikl/KRbI5
        o66GRVxfqx/2MP2GD8rC0ZvsQcuobhhbSjlOYF5s94AmA+g8prsprh6pZBBtTo2EIG5ZI0
        wKA2yQfAjz/+B+jmRxetHtRD5EvZiMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-PpH3tr8KPEKqxvZOtIHIqQ-1; Mon, 06 Jan 2020 21:50:05 -0500
X-MC-Unique: PpH3tr8KPEKqxvZOtIHIqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1C0910054E3;
        Tue,  7 Jan 2020 02:50:04 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6294F60BEC;
        Tue,  7 Jan 2020 02:49:59 +0000 (UTC)
Subject: Re: [PATCH] ceph: allocate the accurate extra bytes for the session
 features
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200103025950.27659-1-xiubli@redhat.com>
 <86323475453efb218f04642297439fd22f567a56.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f5669b6c-8150-20d8-1a76-c4bf2d295af4@redhat.com>
Date:   Tue, 7 Jan 2020 10:49:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <86323475453efb218f04642297439fd22f567a56.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/6 23:23, Jeff Layton wrote:
> On Thu, 2020-01-02 at 21:59 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The totally bytes maybe potentially larger than 8.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 18 ++++++++++++------
>>   1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index ad9573b7e115..aa49e8557599 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1067,20 +1067,20 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>>   	return msg;
>>   }
>>   
>> +static const unsigned char feature_bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
>>   static void encode_supported_features(void **p, void *end)
>>   {
>> -	static const unsigned char bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
>> -	static const size_t count = ARRAY_SIZE(bits);
>> +	static const size_t count = ARRAY_SIZE(feature_bits);
>>   
>>   	if (count > 0) {
>>   		size_t i;
>> -		size_t size = ((size_t)bits[count - 1] + 64) / 64 * 8;
>> +		size_t size = ((size_t)feature_bits[count - 1] + 64) / 64 * 8;
> The bug looks real, though it's not really a problem until we get to
> flag 65. Note too that this calculation relies on having the highest
> feature bit value as the last element of the array. That's probably
> worth a comment in mds_client.h so we don't screw that up later.

Yeah, this makes sense.


>
> Also, I think this would be better expressed using DIV_ROUND_UP, and
> since we have this calculation in two places, maybe do something like:
>
>      #define FEATURE_WORDS  (DIV_ROUND_UP(feature_bits[count - 1], 64) * 8)
>
> ...and then plug that macro into both places.

Will address it.

Thanks.


>>   		BUG_ON(*p + 4 + size > end);
>>   		ceph_encode_32(p, size);
>>   		memset(*p, 0, size);
>>   		for (i = 0; i < count; i++)
>> -			((unsigned char*)(*p))[i / 8] |= 1 << (bits[i] % 8);
>> +			((unsigned char*)(*p))[i / 8] |= 1 << (feature_bits[i] % 8);
>>   		*p += size;
>>   	} else {
>>   		BUG_ON(*p + 4 > end);
>> @@ -1101,6 +1101,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>   	int metadata_key_count = 0;
>>   	struct ceph_options *opt = mdsc->fsc->client->options;
>>   	struct ceph_mount_options *fsopt = mdsc->fsc->mount_options;
>> +	size_t size, count;
>>   	void *p, *end;
>>   
>>   	const char* metadata[][2] = {
>> @@ -1118,8 +1119,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>   			strlen(metadata[i][1]);
>>   		metadata_key_count++;
>>   	}
>> +
>>   	/* supported feature */
>> -	extra_bytes += 4 + 8;
>> +	size = 0;
>> +	count = ARRAY_SIZE(feature_bits);
>> +	if (count > 0)
>> +		size = ((size_t)feature_bits[count - 1] + 64) / 64 * 8;
>> +	extra_bytes += 4 + size;
>>   
>>   	/* Allocate the message */
>>   	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
>> @@ -1139,7 +1145,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>>   	 * Serialize client metadata into waiting buffer space, using
>>   	 * the format that userspace expects for map<string, string>
>>   	 *
>> -	 * ClientSession messages with metadata are v2
>> +	 * ClientSession messages with metadata are v3
>>   	 */
>>   	msg->hdr.version = cpu_to_le16(3);
>>   	msg->hdr.compat_version = cpu_to_le16(1);


