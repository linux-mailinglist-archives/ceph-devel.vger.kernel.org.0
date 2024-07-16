Return-Path: <ceph-devel+bounces-1531-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8509932226
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 10:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F394280EE9
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jul 2024 08:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0AF17D379;
	Tue, 16 Jul 2024 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6HPG/N0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A3E43146
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721119478; cv=none; b=n9NSmvdUn1fMPPbSvXEzGMVXFIG0Ei/HP8vO5p2GmjvSYHKh4s7PHpqvUe1kdQfHBjaKZuXYyyGX9D9u8U89H1qiXOMgeV1mgRPw612TeMVaR6cEQutRecdqS+JxTvcddm4yeuEYBMC0mfcx0YsW/+91oEIXeOxQrvxIruQ9yP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721119478; c=relaxed/simple;
	bh=bJgFpj7HSjVp+2XEzLICb30ytlLsa2sPDPnYN72jVhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUh+ULsiF9/oTCbcwYpfg7pEnxouTKLo0bjU2dFWjuKUhfC9rQMdzEv6iCn8gp/dmlFNGCxjwbeCyMTXgVS2VP8WGiEMS0q+lofvBzrRp7FNzNZO8677570f4XFnnPQmNrmHPi83SCgMt1RyKLrgDhGKIjvfjc6pSUHFqKcfBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6HPG/N0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721119475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23o/XGTBuRL7DJpbS8tEUOVYjPKAI+3lkmMp5biIX9g=;
	b=g6HPG/N0vwLJC9eSY/uYtPYtiuyZtIfETum0pktVXyXqCXx2mB0KpBVcjI1s4l6g8N2xXK
	pd1h0gJjdPhGFVfe81q/a1nOOuAbHkfwMAkPvgJvSUkUPdqiuPGyKtfOVuUkUV+GU9VPau
	0Sm6QLFXSBjwohQKwvep+TtoWQqxdEk=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-EH9Um999P6m1Gf2er_sAQA-1; Tue, 16 Jul 2024 04:44:34 -0400
X-MC-Unique: EH9Um999P6m1Gf2er_sAQA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-75fa4278316so3362398a12.3
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jul 2024 01:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721119473; x=1721724273;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=23o/XGTBuRL7DJpbS8tEUOVYjPKAI+3lkmMp5biIX9g=;
        b=n/B9WBHLmOayK+41ZWFth8H0D4LVe7p4ya1J95Z1stk3I1VpdwBXSkUWR9NP9d2ac5
         g7SYyHalAISAXjFRIvvSBz7S475xu/dYquZwM4Ih3TH1BMv4AxBE+n79tXPdld1vidou
         2jYW1zwUtIbiuBvC6mrE7N2/dyFgPz32+SRfatk9i3MI/QSNo0Oso/dOXTWxv4cEQkGK
         wpcwy2MrATyQFGRHlj/5HgCo5J93YPOKOpl8jbrJ6givTgmJDdDdqE+zScBXqmJa7EXm
         VjAKbn5LBT3BirqTVOk/JHuKkKCO3z7qV/SdPV8OqF/NmRSiUB2OPbpzkvxH6hkQJLnT
         wZGQ==
X-Gm-Message-State: AOJu0Yyd6zOnF7fskh/qQCOWkxZhYwO4YF84vl0pY7gZNF5rr5E8fSho
	bij7LuU6cFpfOzFwwiyuF4O8qs4V/WFaQFcQhqwoKInzRq4Ot0QIhxc+N2CIRyI4tCXh6zd7qat
	pw5JvtyFncSd/79h0GaafnB38Xgg1HzNcqtZF7HyMZhIMgFuuWCT3HL2Q3M5ad7sXcr1bZw==
X-Received: by 2002:a05:6a20:6a1c:b0:1c0:f5ea:d447 with SMTP id adf61e73a8af0-1c3f124bc61mr1716443637.31.1721119472977;
        Tue, 16 Jul 2024 01:44:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuhwZ8MUsO3VjyJAJJSNdyWpTUivpRh9m1rSzOkaojLNjlmJv24ndTc4XZ84/nAM9tAlDBGQ==
X-Received: by 2002:a05:6a20:6a1c:b0:1c0:f5ea:d447 with SMTP id adf61e73a8af0-1c3f124bc61mr1716430637.31.1721119472618;
        Tue, 16 Jul 2024 01:44:32 -0700 (PDT)
Received: from [10.72.116.106] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fc0ee8ad03sm53405115ad.246.2024.07.16.01.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 01:44:32 -0700 (PDT)
Message-ID: <875d0760-f5fa-4516-b7b5-9011fa8f6049@redhat.com>
Date: Tue, 16 Jul 2024 16:44:27 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: force sending a cap update msg back to MDS for
 revoke op
To: Venky Shankar <vshankar@redhat.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, stable@vger.kernel.org
References: <20240711104019.987090-1-xiubli@redhat.com>
 <CACPzV1kjU5KYynz4KX9=z6LB6KELUqCZOBc126bpgpyrzRaWsQ@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1kjU5KYynz4KX9=z6LB6KELUqCZOBc126bpgpyrzRaWsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/16/24 16:00, Venky Shankar wrote:
> Hi Xiubo,
>
> On Thu, Jul 11, 2024 at 4:10 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If a client sends out a cap update dropping caps with the prior 'seq'
>> just before an incoming cap revoke request, then the client may drop
>> the revoke because it believes it's already released the requested
>> capabilities.
>>
>> This causes the MDS to wait indefinitely for the client to respond
>> to the revoke. It's therefore always a good idea to ack the cap
>> revoke request with the bumped up 'seq'.
>>
>> Currently if the cap->issued equals to the newcaps the check_caps()
>> will do nothing, we should force flush the caps.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://tracker.ceph.com/issues/61782
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c  | 16 ++++++++++++----
>>   fs/ceph/super.h |  7 ++++---
>>   2 files changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 24c31f795938..ba5809cf8f02 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -2024,6 +2024,8 @@ bool __ceph_should_report_size(struct ceph_inode_info *ci)
>>    *  CHECK_CAPS_AUTHONLY - we should only check the auth cap
>>    *  CHECK_CAPS_FLUSH - we should flush any dirty caps immediately, without
>>    *    further delay.
>> + *  CHECK_CAPS_FLUSH_FORCE - we should flush any caps immediately, without
>> + *    further delay.
>>    */
>>   void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>>   {
>> @@ -2105,7 +2107,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>>          }
>>
>>          doutc(cl, "%p %llx.%llx file_want %s used %s dirty %s "
>> -             "flushing %s issued %s revoking %s retain %s %s%s%s\n",
>> +             "flushing %s issued %s revoking %s retain %s %s%s%s%s\n",
>>               inode, ceph_vinop(inode), ceph_cap_string(file_wanted),
>>               ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
>>               ceph_cap_string(ci->i_flushing_caps),
>> @@ -2113,7 +2115,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>>               ceph_cap_string(retain),
>>               (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
>>               (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
>> -            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
>> +            (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "",
>> +            (flags & CHECK_CAPS_FLUSH_FORCE) ? " FLUSH_FORCE" : "");
>>
>>          /*
>>           * If we no longer need to hold onto old our caps, and we may
>> @@ -2223,6 +2226,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>>                                  goto ack;
>>                  }
>>
>> +               if (flags & CHECK_CAPS_FLUSH_FORCE)
>> +                       goto ack;
> Maybe check this early on inside the
>
>          for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
>
>
>          }
>
> loop?

Yeah, we can do this ealier, let me improved it.

Thanks

- Xiubo


>> +
>>                  /* things we might delay */
>>                  if ((cap->issued & ~retain) == 0)
>>                          continue;     /* nope, all good */
>> @@ -3518,6 +3524,7 @@ static void handle_cap_grant(struct inode *inode,
>>          bool queue_invalidate = false;
>>          bool deleted_inode = false;
>>          bool fill_inline = false;
>> +       int flags = 0;
>>
>>          /*
>>           * If there is at least one crypto block then we'll trust
>> @@ -3751,6 +3758,7 @@ static void handle_cap_grant(struct inode *inode,
>>          /* don't let check_caps skip sending a response to MDS for revoke msgs */
>>          if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
>>                  cap->mds_wanted = 0;
>> +               flags |= CHECK_CAPS_FLUSH_FORCE;
>>                  if (cap == ci->i_auth_cap)
>>                          check_caps = 1; /* check auth cap only */
>>                  else
>> @@ -3806,9 +3814,9 @@ static void handle_cap_grant(struct inode *inode,
>>
>>          mutex_unlock(&session->s_mutex);
>>          if (check_caps == 1)
>> -               ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
>> +               ceph_check_caps(ci, flags | CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL);
>>          else if (check_caps == 2)
>> -               ceph_check_caps(ci, CHECK_CAPS_NOINVAL);
>> +               ceph_check_caps(ci, flags | CHECK_CAPS_NOINVAL);
>>   }
>>
>>   /*
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index b0b368ed3018..831e8ec4d5da 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -200,9 +200,10 @@ struct ceph_cap {
>>          struct list_head caps_item;
>>   };
>>
>> -#define CHECK_CAPS_AUTHONLY   1  /* only check auth cap */
>> -#define CHECK_CAPS_FLUSH      2  /* flush any dirty caps */
>> -#define CHECK_CAPS_NOINVAL    4  /* don't invalidate pagecache */
>> +#define CHECK_CAPS_AUTHONLY     1  /* only check auth cap */
>> +#define CHECK_CAPS_FLUSH        2  /* flush any dirty caps */
>> +#define CHECK_CAPS_NOINVAL      4  /* don't invalidate pagecache */
>> +#define CHECK_CAPS_FLUSH_FORCE  8  /* force flush any caps */
>>
>>   struct ceph_cap_flush {
>>          u64 tid;
>> --
>> 2.45.1
>>
>


