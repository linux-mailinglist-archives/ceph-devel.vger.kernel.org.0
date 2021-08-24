Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D483F555E
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Aug 2021 03:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhHXBH6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 21:07:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233616AbhHXBH5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 21:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629767233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7QRfXM5efbQSwehoTaqgWpU5SA6JznvKxvueXK1pq9k=;
        b=RzaetkU1xRIreUCgB2cIJ6Aha6m716SLJllrMuPUxNvl9QEim2ZE4HnRJdvbWw6lqKikfg
        aRhEbFmOLoXQUDP/gz2dvHrYSU53bjm7NcGvibpp3nf96yS0HzvY55Jd43WRkgqVh1Wjnz
        NdSLWBreZ/OULShRxxXQjm4FmeLBNkg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-u0JLyw4JOAGdYoxFbPzzwQ-1; Mon, 23 Aug 2021 21:07:12 -0400
X-MC-Unique: u0JLyw4JOAGdYoxFbPzzwQ-1
Received: by mail-pg1-f199.google.com with SMTP id t28-20020a63461c000000b00252078b83e4so11165030pga.15
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 18:07:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7QRfXM5efbQSwehoTaqgWpU5SA6JznvKxvueXK1pq9k=;
        b=CrX1pj2xfqq3eZDcg3iAmn3o6bulvqdLyn7Xes59vlmDTu/xXSG/h4r4qYF8RSffkd
         aX21hxG12kXbkrc+aAuw5lVpYy/zXwjorgQmig54rAN3Qa4m93pUHwFKCZKwRUuvrnow
         U0MLP3NazBtnVob9at5fnyplesFT5oLfOGpRgYyVl477mMiLrHKgPThY9mlFpTyi5WTA
         9cphpRp+br99tkFXEkkkWgjla1dlQ2/NVz1UUYNt2r8c9tmu3j2yWwhLk9i2Sa+2CLSF
         uVh2W7J6Sk8DngqWKNPCmdc6yzc+yqT0EMzMcoucU4E5DxiAG0GyTX5KroMNBgJkLlH3
         1MSg==
X-Gm-Message-State: AOAM533WFHGZFQXff66zGKXuq8pO8dVPSItqSqfCs4xNR//ZaC5Tv72c
        Nvk4mjFDOLePkn7VOCBXvh0fVnjuYyP6Uv+KHDGneIO25JfGu4KcSwPWwvwHc8pQu/Je5phlNTW
        COenvDTHBHKc2yOS3rlV8/UdgUqWmj8BvIqB2GtlgEHFMZsvDej+7+F4/OCriqcUCdeZ4J7I=
X-Received: by 2002:a17:90b:613:: with SMTP id gb19mr1400175pjb.77.1629767231195;
        Mon, 23 Aug 2021 18:07:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+dDzq8+fkMUOZdRTTPBOJTPFBUqs5ETEO1Tx862wJLRQ+FvUw+MndV5NwpHoSFIqZF9KhEw==
X-Received: by 2002:a17:90b:613:: with SMTP id gb19mr1400153pjb.77.1629767230911;
        Mon, 23 Aug 2021 18:07:10 -0700 (PDT)
Received: from [10.72.12.33] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c15sm397957pjr.22.2021.08.23.18.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 18:07:10 -0700 (PDT)
Subject: Re: [PATCH 2/3] ceph: don't WARN if we're force umounting
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210818080603.195722-1-xiubli@redhat.com>
 <20210818080603.195722-3-xiubli@redhat.com>
 <7bf49c80528b31f6350d7f3ee2a5a69da42aaa69.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f6950e48-62cd-9dc0-0bd4-f7a492ca4311@redhat.com>
Date:   Tue, 24 Aug 2021 09:07:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7bf49c80528b31f6350d7f3ee2a5a69da42aaa69.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/23/21 9:49 PM, Jeff Layton wrote:
> On Wed, 2021-08-18 at 16:06 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Force umount will try to close the sessions by setting the session
>> state to _CLOSING, so in ceph_kill_sb after that it will warn on it.
>>
>> URL: https://tracker.ceph.com/issues/52295
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index a632e1c7cef2..0302af53e079 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4558,6 +4558,8 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>>   
>>   bool check_session_state(struct ceph_mds_session *s)
>>   {
>> +	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
>> +
>>   	switch (s->s_state) {
>>   	case CEPH_MDS_SESSION_OPEN:
>>   		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
>> @@ -4566,8 +4568,11 @@ bool check_session_state(struct ceph_mds_session *s)
>>   		}
>>   		break;
>>   	case CEPH_MDS_SESSION_CLOSING:
>> -		/* Should never reach this when we're unmounting */
>> -		WARN_ON_ONCE(s->s_ttl);
>> +		/*
>> +		 * Should never reach this when none force unmounting
>> +		 */
>> +		if (READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN)
>> +			WARN_ON_ONCE(s->s_ttl);
> How about something like this instead?
>
>      WARN_ON_ONCE(s->s_ttl && READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);


This looks good to me too. Will fix it.

Thanks


>
>>   		fallthrough;
>>   	case CEPH_MDS_SESSION_NEW:
>>   	case CEPH_MDS_SESSION_RESTARTING:

