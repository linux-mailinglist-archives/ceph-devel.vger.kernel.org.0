Return-Path: <ceph-devel+bounces-910-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB52C8684D1
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 01:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1998A1F22343
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 00:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE14817F0;
	Tue, 27 Feb 2024 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T9SJJD41"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C2B1103
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 00:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708992093; cv=none; b=Wg9RBrv+r3UQhmk7XtgtqyWiUEME2C7xuPPbg8pe1tF5f7ZmUIKJeN7x2cU/z9HNqoiQLjHVeGzfqMFCBfppV2eoOR6H1tam5YS0IezR64cB1pEHWb8fdA/GjB36t9MRZluv11cauDGTVCQ/Cfmk5gfYGqn10oU3iSCCcQkYVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708992093; c=relaxed/simple;
	bh=BpFFzjnNTd1eS4k42CK9yngvQD2OxOHrTBWBP/BT5M0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9xysokduXuTBLfm2TeGh9HcViAHLi8uDD/LjFLT3cwh23yYiaSvAciC5vEkRzI7+AOzYRsp1n7qfuJHCcb1kKeloRhJMUeFQjSwtpJ4dnp8frxG0zId+WJ5QcGfGcUbomkwY/fCNz2ooF+pnXcEfmcZ2ChSmnP+fXRUwF+PZTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T9SJJD41; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708992090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BIGN4YqOE+2N/qYW4lMoo79/wkusmthclrn+r/dC+lA=;
	b=T9SJJD41daaJthyVle0rbHL5WcZmRfozm58025nwp1PupX/PeXX83FfHjEI7kH4qXb1NPW
	C0AvFuGBbmdpdD6OAMtdE2nd4sXFIo8F9KkHqUSu0yHbFaXykAWf/NkVZIW4Mip3sSAxca
	WVsAQFjY7l+o/2Zp6iTJbwE09UFPZ3Y=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-6vdV4g-vPC-uXamuvQoJsg-1; Mon, 26 Feb 2024 19:01:21 -0500
X-MC-Unique: 6vdV4g-vPC-uXamuvQoJsg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5dc1548ac56so2400579a12.3
        for <ceph-devel@vger.kernel.org>; Mon, 26 Feb 2024 16:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708992080; x=1709596880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BIGN4YqOE+2N/qYW4lMoo79/wkusmthclrn+r/dC+lA=;
        b=pcvLXOgtenGlunBQA04u6S+2uMRGc4Gb7oeujV9OIST4fSmKi8Ks4FTQbYOa/uD/lo
         vVwFNH+b73U6QvH+47mSC7QwGu1HaGxOUrtw0HWnoQKfbZjHSju0yMXbbMNAOwLR11TJ
         sjc+qSBMhybmbMGgYfnXMHzlEvWrc8PICTlxvhnBsTTlR/LTUU/gxDApDNj5+Edw6pum
         FTvqjJ2kmGMrptPQklkAviMnWXm+C2JXPMjgbCC1K9s3TeRQ9Tt1mFHO1gqYwP75uTxW
         RUQ31BsbTHlvi58ve03AmGuVbtBTvP6s1m9qnV/fVllbuotQjWWYQSMdvWja0xbdrVeS
         W8fQ==
X-Gm-Message-State: AOJu0YzZDLugf9Rbiy9zkvwtcbnVXKH9C82zXOf9E6ln/iVenzg8Lv71
	JFUZChyiVD2Y7Ucs+vernvSINjzAmgq77uOLwbQLg0PYQVM1/FI1DLF7Quoir1IfW93laFRxiLS
	G3zJNzIUhS3OAotVbCfQbZqrpY6PgTxzlB8T0t3mzFJMvtTGE+b9bzY+gJj4=
X-Received: by 2002:a05:6a20:3887:b0:1a0:d2ca:d3b6 with SMTP id n7-20020a056a20388700b001a0d2cad3b6mr477752pzf.34.1708992080011;
        Mon, 26 Feb 2024 16:01:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHa4qb0xyrHPmKckGpoD3xv0OmEZPBT4qgx2BVIz1hU/CnA/cTboSg7BQvpcxqPRaNiyxrkxw==
X-Received: by 2002:a05:6a20:3887:b0:1a0:d2ca:d3b6 with SMTP id n7-20020a056a20388700b001a0d2cad3b6mr477737pzf.34.1708992079621;
        Mon, 26 Feb 2024 16:01:19 -0800 (PST)
Received: from [10.72.112.214] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gu5-20020a056a004e4500b006e31f615af6sm4770355pfb.17.2024.02.26.16.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 16:01:19 -0800 (PST)
Message-ID: <3c212e94-d638-46cf-9669-4a881fa5d65c@redhat.com>
Date: Tue, 27 Feb 2024 08:01:13 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ceph: reverse MDSMap dencoding of
 max_xattr_size/bal_rank_mask
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com, Patrick Donnelly <pdonnell@redhat.com>,
 Patrick Donnelly <pdonnell@ibm.com>
References: <20240221045158.75644-1-xiubli@redhat.com>
 <CAOi1vP_194e3iemuUTVJzmdYn1AyuJ1PnCnrx9c3_pPxgNUxTw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_194e3iemuUTVJzmdYn1AyuJ1PnCnrx9c3_pPxgNUxTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/27/24 02:32, Ilya Dryomov wrote:
> On Wed, Feb 21, 2024 at 5:54 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Ceph added the bal_rank_mask with encoded (ev) version 17.  This
>> was merged into main Oct 2022 and made it into the reef release
>> normally. While a latter commit added the max_xattr_size also
>> with encoded (ev) version 17 but places it before bal_rank_mask.
>>
>> And this will breaks some usages, for example when upgrading old
>> cephs to newer versions.
>>
>> URL: https://tracker.ceph.com/issues/64440
>> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Reviewed-by: Patrick Donnelly <pdonnell@ibm.com>
>> Reviewed-by: Venky Shankar <vshankar@redhat.com>
>> ---
>>
>> V3:
>> - Fix the comment suggested by Patrick in V2.
>>
>>
>>   fs/ceph/mdsmap.c | 7 ++++---
>>   fs/ceph/mdsmap.h | 6 +++++-
>>   2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
>> index fae97c25ce58..8109aba66e02 100644
>> --- a/fs/ceph/mdsmap.c
>> +++ b/fs/ceph/mdsmap.c
>> @@ -380,10 +380,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
>>                  ceph_decode_skip_8(p, end, bad_ext);
>>                  /* required_client_features */
>>                  ceph_decode_skip_set(p, end, 64, bad_ext);
>> +               /* bal_rank_mask */
>> +               ceph_decode_skip_string(p, end, bad_ext);
>> +       }
>> +       if (mdsmap_ev >= 18) {
>>                  ceph_decode_64_safe(p, end, m->m_max_xattr_size, bad_ext);
>> -       } else {
>> -               /* This forces the usage of the (sync) SETXATTR Op */
>> -               m->m_max_xattr_size = 0;
>>          }
>>   bad_ext:
>>          doutc(cl, "m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
>> diff --git a/fs/ceph/mdsmap.h b/fs/ceph/mdsmap.h
>> index 89f1931f1ba6..1f2171dd01bf 100644
>> --- a/fs/ceph/mdsmap.h
>> +++ b/fs/ceph/mdsmap.h
>> @@ -27,7 +27,11 @@ struct ceph_mdsmap {
>>          u32 m_session_timeout;          /* seconds */
>>          u32 m_session_autoclose;        /* seconds */
>>          u64 m_max_file_size;
>> -       u64 m_max_xattr_size;           /* maximum size for xattrs blob */
>> +       /*
>> +        * maximum size for xattrs blob.
>> +        * Zeroed by default to force the usage of the (sync) SETXATTR Op.
>> +        */
>> +       u64 m_max_xattr_size;
>>          u32 m_max_mds;                  /* expected up:active mds number */
>>          u32 m_num_active_mds;           /* actual up:active mds number */
>>          u32 possible_max_rank;          /* possible max rank index */
>> --
>> 2.43.0
>>
> I have expanded the changelog and tagged stable as we definitely want
> this backported.  Please let me know if I got something wrong:
>
> https://github.com/ceph/ceph-client/commit/51d31149a88b5c5a8d2d33f06df93f6187a25b4c

Thanks Ilya. Looks nice.

Yeah, we need to backport this asap.

- Xiubo


> Thanks,
>
>                  Ilya
>


