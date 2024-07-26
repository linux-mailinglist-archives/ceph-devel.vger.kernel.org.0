Return-Path: <ceph-devel+bounces-1567-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F4E93CC87
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 03:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BDF6282441
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2024 01:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25302AD31;
	Fri, 26 Jul 2024 01:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aK2blC56"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05443848C
	for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2024 01:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721958108; cv=none; b=tlH1UlF6/p9O4zJemkDG/do0iGzOkaHmU8UiS9oLJzo3zPZvOlB0aiJXnq1MbKWPyLTfb+JqWMWDZH+NNZDJqSKBRhqhrRXCVZfkwC4JxdR+JhWrUoWKRB9pqgDrNOXfNHH8mKPHF7kvk9C+AQKlW4gh6CZkc/QQ00VoyO5dVtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721958108; c=relaxed/simple;
	bh=o3HnjrWlITcEfZpqbTHl4tyfWAfMWz6+riSbKTagLco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AyJpW4sHYgsaAfd3Io9uVZqmyxUFCoDDBOsOyFJwVi9jr00JMz+DUGzzQGLMcS9YwHrb22PEAJEqIDPhI6Cal4Jd11cGjIfX6MZJKlQxfrpo2tZchWKYI6/IC1X/qljfr+iPc7YbKuB8idnRCNVfdQsj0PkbHdDHEExYna/8Mgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aK2blC56; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721958105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eaOMRhY/gRejCiB3H5KoMMK1aCX64UdyNisj6DkIbYc=;
	b=aK2blC56IjVGSofLuZStUMBja/4+jxn/tZsnPMbdIrtUv2fbgkImGrWwWJuNy7eZu2y6Ay
	1hc1HM4homSLXxjC0KsBa2JR0rFUJEs+7DEo4aEQacehRL/47nMVGW/f9I+oNiCCkKwRCf
	jl9xMpvR8MTmpkelgFxIu5U5VY/deSM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-_uG_YdUbObKKQ1B6o1NeTA-1; Thu, 25 Jul 2024 21:41:44 -0400
X-MC-Unique: _uG_YdUbObKKQ1B6o1NeTA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1fc52d3c76eso2061835ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 18:41:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721958103; x=1722562903;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eaOMRhY/gRejCiB3H5KoMMK1aCX64UdyNisj6DkIbYc=;
        b=e/GVwXAyfV4Vep0sZbKN+8VxxTu3+GDamcd4My//wGPr5GTczurYqozHn9EPFLpEzL
         HLD799ZQnrHyvJnszYQfK9fzVRvc6XBKwlXGhi8dyEXpAQJ6wDZnq1N63BzbTKNQAhQt
         QxdzZUaRa54/L8td8OGDtRf1puvnionKsdhsKJ+JWguSQlmpFclRDIliBNPtnoHP2mYw
         V5MSTr2Q+OHPF6qZIAOUmTMLWOraPAi9AYY0E+ndpRSLi9kLYxBwRNHfZJBnxJLIdBdY
         JONIFWkbZ2NjrmW9weUL3Exszg+E9Bk66sdmtlNTP1PSjzq/5SA0FcYFHFbnhkJHF3MQ
         cvcg==
X-Gm-Message-State: AOJu0Yx0OgF9K3KlBF6lhqeLVqN3sfRc/Bxgn5dWTa34sXJtWOwjl7rp
	H4e9ifF/6Efbl+moP9sRGbkaj3YnK8yDgqVfNwv5AJ8CTLciIrH4hCFmC7PTdfbfizKTU2I/THA
	t7ZzZnvQ9v7iqNOVUQ/e/GCnTXtdqv2xIpBQvMz4BIQUzyThfCIrrzsekWrA=
X-Received: by 2002:a17:903:32ce:b0:1fc:71fb:10d6 with SMTP id d9443c01a7336-1fed352fd44mr52630255ad.6.1721958102840;
        Thu, 25 Jul 2024 18:41:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVwes48W5IHUAfJqPQlO+VKA3ekAdkvW4TtjeJ+ONnDUCYG2nahUGE/QByRqvVcriyAyh9LQ==
X-Received: by 2002:a17:903:32ce:b0:1fc:71fb:10d6 with SMTP id d9443c01a7336-1fed352fd44mr52630075ad.6.1721958102367;
        Thu, 25 Jul 2024 18:41:42 -0700 (PDT)
Received: from [10.72.116.41] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7cf1db4sm20741095ad.87.2024.07.25.18.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 18:41:42 -0700 (PDT)
Message-ID: <c69c688b-98ba-4c45-a45a-eefdf1fa467e@redhat.com>
Date: Fri, 26 Jul 2024 09:41:36 +0800
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
 <CACPzV1=3m3zKcBuUKTYD6JfkSvo9dTuPU_8shrNBOEdBeSZDuA@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1=3m3zKcBuUKTYD6JfkSvo9dTuPU_8shrNBOEdBeSZDuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/25/24 19:41, Venky Shankar wrote:
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
> v3 pathset looks good.
>
> Reviewed-by: Venky Shankar <vshankar@redhat.com>
> Tested-by: Venky Shankar <vshankar@redhat.com>
Thanks Venky.
>


