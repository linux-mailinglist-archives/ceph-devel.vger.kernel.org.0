Return-Path: <ceph-devel+bounces-1555-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C2C93BA00
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 03:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F7E8282234
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 01:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CB34C74;
	Thu, 25 Jul 2024 01:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wct5/XgE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F2B46B8
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 01:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721869300; cv=none; b=QtL213M+SdgB8HTooM/Nnej1N7t5ERJTXAdF0I/NovVEbNPCzRusF64qdOYTjaES5jrohgrBPIc9EXtHAC172QaB926U7GsAMYfKY9vA+9wfg1O2AM3hor9F0gYHYdOAAvQa5wQeMOMadSfy8HlCLE+gej7s2C3kQZ4NokNSDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721869300; c=relaxed/simple;
	bh=xUw1jd/fVHdRlnKbMv992HK33EUVpkasvroEwL0Njfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kIUc5Cv7dxi7nZL1nQtiP6WO5fFp3fE4YvrZ+TlIh5HFxHPTVvwBoFMOvgwskdLhajQE/zDQ13oRqOk+9O0shyRLgBvmLDQUXJ0vI1dqb9vJO6dORVI2GfGKbX0G7zrKstRmv9RisGpHAOHYIKdXjW67djd7MSji5NjLZWD8X6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wct5/XgE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721869296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IF79gs5zkGKc+lyAIErK1XibkHIn6L6Zg67dINICfpg=;
	b=Wct5/XgEO/Oiukgo5uTvsCn38rhKeE0jGlvU1d0EshMDiTHZZbCpqaWjSsq2iV/00fPPLf
	/4bsK8VyazRyCavkN+qpmwgRZNYIIMVyNpSIz+rku/RQuDIREUZJZm+V8GhavEIK8jsXeo
	D6l5V+OGMaK8YZU/2wjX2T0/AUUT7zA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-iHaiiDbzMSaju8Hza454DQ-1; Wed, 24 Jul 2024 21:01:31 -0400
X-MC-Unique: iHaiiDbzMSaju8Hza454DQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-70e910f309eso417208b3a.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 18:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721869287; x=1722474087;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IF79gs5zkGKc+lyAIErK1XibkHIn6L6Zg67dINICfpg=;
        b=fbSKMKTXDYxQcGZCJEEFXGeZ5j6CR85LHcay3P3KQ05tklj0y2D+HDhTDuYIYACXKQ
         HpTggUd3r2f4WLPtgJgeG4ESlYodghHaxOAKmvo9ur9lERqF0hiHIOjtfWpvpuTnOJGa
         J67UX4kAi+3xcFNBCtFKybBWprgiBC3uCHOiTjg4AlY7MsTtI/lwLMuWYMoTV4yN6ct/
         x6yPS3n0BuI+X7zn4hNMuH+BieK2JEh2YQ1A+EhkFUDsLUFDAPU9vUa+ypeVnDBHwEIM
         dY62rYBrJaZt7w1K6LaQVmxYpXG/nexWVbSPx5qGRyTMCEwzWo4VSPFYG8i3SqVSP5vo
         B/WQ==
X-Gm-Message-State: AOJu0Yz1L2pqT06MXTkyPdsBHQQDVRH8/0ogSvhwTos5bJD4q0w+Muod
	UCyNNFecNF2NXB5OJGr0OvcW3N85V2KMQ49tgTCsvF6UJ/w2ApBDrThoYeng4ix7HIiFgGtHf5S
	i7fAiTlKJbINOnEW+M98uDftWDspe1Ho2pYvsN+ngx1USjqG0X/VZq07fS2k=
X-Received: by 2002:a05:6a00:21ce:b0:70d:2892:402b with SMTP id d2e1a72fcca58-70eae8e89ddmr361522b3a.7.1721869287189;
        Wed, 24 Jul 2024 18:01:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJ7C6omw76l7g382tw16XlmfO9GOPsiouXgv0UefzBPUSh33wS5/2nsb0utnKxxGo+Sor88A==
X-Received: by 2002:a05:6a00:21ce:b0:70d:2892:402b with SMTP id d2e1a72fcca58-70eae8e89ddmr361471b3a.7.1721869286480;
        Wed, 24 Jul 2024 18:01:26 -0700 (PDT)
Received: from [10.72.116.41] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead7156c8sm167717b3a.83.2024.07.24.18.01.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 18:01:26 -0700 (PDT)
Message-ID: <dac1bb9f-c544-4c56-b1eb-b565a6405f76@redhat.com>
Date: Thu, 25 Jul 2024 09:01:21 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ceph: force sending a cap update msg back to MDS for
 revoke op
To: Venky Shankar <vshankar@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, stable@vger.kernel.org
References: <20240716120724.134512-1-xiubli@redhat.com>
 <CACPzV1kqN49AW4ihgd0yDvmaujMWKr+4B7tonnUpn=dPPs6Nhw@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1kqN49AW4ihgd0yDvmaujMWKr+4B7tonnUpn=dPPs6Nhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/24/24 22:08, Venky Shankar wrote:
> Hi Xiubo,
>
> On Tue, Jul 16, 2024 at 5:37 PM <xiubli@redhat.com> wrote:
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
>>
>> V3:
>> - Move the force check earlier
>>
>> V2:
>> - Improved the patch to force send the cap update only when no caps
>> being used.
>>
>>
>>   fs/ceph/caps.c  | 35 ++++++++++++++++++++++++-----------
>>   fs/ceph/super.h |  7 ++++---
>>   2 files changed, 28 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 24c31f795938..672c6611d749 100644
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
>> @@ -2188,6 +2191,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
>>                                  queue_writeback = true;
>>                  }
>>
>> +               if (flags & CHECK_CAPS_FLUSH_FORCE) {
>> +                       doutc(cl, "force to flush caps\n");
>> +                       goto ack;
>> +               }
>> +
>>                  if (cap == ci->i_auth_cap &&
>>                      (cap->issued & CEPH_CAP_FILE_WR)) {
>>                          /* request larger max_size from MDS? */
>> @@ -3518,6 +3526,8 @@ static void handle_cap_grant(struct inode *inode,
>>          bool queue_invalidate = false;
>>          bool deleted_inode = false;
>>          bool fill_inline = false;
>> +       bool revoke_wait = false;
>> +       int flags = 0;
>>
>>          /*
>>           * If there is at least one crypto block then we'll trust
>> @@ -3713,16 +3723,18 @@ static void handle_cap_grant(struct inode *inode,
>>                        ceph_cap_string(cap->issued), ceph_cap_string(newcaps),
>>                        ceph_cap_string(revoking));
>>                  if (S_ISREG(inode->i_mode) &&
>> -                   (revoking & used & CEPH_CAP_FILE_BUFFER))
>> +                   (revoking & used & CEPH_CAP_FILE_BUFFER)) {
>>                          writeback = true;  /* initiate writeback; will delay ack */
>> -               else if (queue_invalidate &&
>> +                       revoke_wait = true;
>> +               } else if (queue_invalidate &&
>>                           revoking == CEPH_CAP_FILE_CACHE &&
>> -                        (newcaps & CEPH_CAP_FILE_LAZYIO) == 0)
>> -                       ; /* do nothing yet, invalidation will be queued */
>> -               else if (cap == ci->i_auth_cap)
>> +                        (newcaps & CEPH_CAP_FILE_LAZYIO) == 0) {
>> +                       revoke_wait = true; /* do nothing yet, invalidation will be queued */
>> +               } else if (cap == ci->i_auth_cap) {
>>                          check_caps = 1; /* check auth cap only */
>> -               else
>> +               } else {
>>                          check_caps = 2; /* check all caps */
>> +               }
>>                  /* If there is new caps, try to wake up the waiters */
>>                  if (~cap->issued & newcaps)
>>                          wake = true;
>> @@ -3749,8 +3761,9 @@ static void handle_cap_grant(struct inode *inode,
>>          BUG_ON(cap->issued & ~cap->implemented);
>>
>>          /* don't let check_caps skip sending a response to MDS for revoke msgs */
>> -       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
>> +       if (!revoke_wait && le32_to_cpu(grant->op) == CEPH_CAP_OP_REVOKE) {
>>                  cap->mds_wanted = 0;
>> +               flags |= CHECK_CAPS_FLUSH_FORCE;
>>                  if (cap == ci->i_auth_cap)
>>                          check_caps = 1; /* check auth cap only */
>>                  else
>> @@ -3806,9 +3819,9 @@ static void handle_cap_grant(struct inode *inode,
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
> Unfortunately, the test run using this change has unrelated issues,
> therefore, the tests have to be rerun. I'll schedule a fs suite run on
> priority so that we get the results by tomorrow.
>
> Will update once done. Apologies!

No worry. Just take your time.

Thanks Venky!

- Xiubo


