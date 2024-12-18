Return-Path: <ceph-devel+bounces-2385-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AEF29F6960
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 16:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1E261659EF
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 15:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C99A1B042C;
	Wed, 18 Dec 2024 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gKRLmZdM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676EE182C5
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 15:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734534339; cv=none; b=rToYY00TPj9MytRHtCpJ++Wq5iAs43yWLP3IFhIJahLalYlw+HxP0oTuUSO/0oiFc1NotVufutOGwLfigvmSt1FZuZ0wpzE25dUTTHzLxvKWhj+XmJYbRzubT/o6Rpb0j/SozyaBdIj8R1rN36ef1U+B+j+IysU/P0BuwCgpgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734534339; c=relaxed/simple;
	bh=xSYX3BsXuQYXlRKBwSl35pDDBaMEFiVKfHQBP/eNTJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ojDmDNrtpZdDKTLhcwAATH4f1ISmdRgxGYkZhfFSLLsE22zc8cEEX1usv40jGzaKr4jB26a+TtPrs5C43gdn3U7LLAunLHBdyL1tdEnOcbuRnXz0ZUvpeVNHcdM8lCPKjstnBfUYtD1l8zfVzqICzk3RJXj6AR4MUhVCVkc6Zag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gKRLmZdM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734534336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlHpDu8AIfMQa2SfTJqx1r0jV9eFf82JDxdet3bdHNU=;
	b=gKRLmZdMJsyeAsNXH1YcKo2ffnVFcizwK6anXgtUBQ1IGGPgSn9posQnAfjgGpQ4edzEjR
	tgYkEySIM/I1utYzK1Y+x/zSWTqqloQxPSj4rnkgS1nqs+TI4NISpOXANlBmFYy6W1Vb8x
	AhAnjCjHr68cxvbVq/9WQul2ChCPAnE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-0PWN0prfM6yvSwSHFbnBkg-1; Wed, 18 Dec 2024 10:05:34 -0500
X-MC-Unique: 0PWN0prfM6yvSwSHFbnBkg-1
X-Mimecast-MFC-AGG-ID: 0PWN0prfM6yvSwSHFbnBkg
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa680c6aa0eso188039366b.0
        for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 07:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734534332; x=1735139132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlHpDu8AIfMQa2SfTJqx1r0jV9eFf82JDxdet3bdHNU=;
        b=tSvUP7nHAL1P1cHYFf1Ggaf7WzpoY7vOI/OCYcbi3/ccwaSoGHHi6eCHjLgIweqS2u
         5wCWWW2Q/TShXO/rHRCwPEJ5tVxw99nmee5ZLT5JvmIpUCc1jSTfyi4kBUkK8Tf1ECyZ
         We4pw8AGS84y8aJYWbgbePBh2Yub3+MciO18ts4n1UOg5/MVf2bZrKMqQ9izvR7hoVoS
         kIcGS9B4SPAizZ8wrVIe9ai+pJHZHYe6iwzuYXl3NbqRuW0MQ+fuLXXjD3O+QiDYNTo2
         ZXMrpNaT6ZG4P2dXYet8h7s3CE3yH3kQyWWWeE9fE/JHmkmBH5vgUczEqqd66o170E+1
         kLzQ==
X-Gm-Message-State: AOJu0YxVFM/Co3Tthi0xg+8q7IY7h/oa2RB2T3d+bctAPwEp3SY70dTs
	SbIqrYuDH33YLhJc7jevq3Oh/cjoPXA37wUI1CgHFFT/swxttpqUHgJXa9UmlMCoRKnRVSnlj/d
	6Xzw2a5hLEDzCaHHuuv8tJvHT0ybiOL1SrV6W5e5NQnHzVAucYKaLbVBa0as6lmQzuasuoq6jBt
	92y7ul+Hr0SY0cKJI6EMcat7hsmsz5SaarmQ==
X-Gm-Gg: ASbGncvE1Hkep1ILcupOqVKEdr06wBvmWMZbXydd71pSMRB36X/rytd7sIHlMdi5sVf
	S5cRynTdv5SEFetXDE9y5W42M0tq2bm/t45j72g==
X-Received: by 2002:a05:6402:4584:b0:5d2:60d9:a2a0 with SMTP id 4fb4d7f45d1cf-5d7ee410d11mr3133711a12.33.1734534332229;
        Wed, 18 Dec 2024 07:05:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFcuAGXBEADNPDrWOZSQb9ksgPp2pCUQFb9+3WSKbjAcQYqT+7dcEa1lIP0RZ4v2Ql1FOA/R/SwNrghyZeie5Y=
X-Received: by 2002:a05:6402:4584:b0:5d2:60d9:a2a0 with SMTP id
 4fb4d7f45d1cf-5d7ee410d11mr3133639a12.33.1734534331548; Wed, 18 Dec 2024
 07:05:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <84603f88-a5e9-466a-b632-0ba8729c2187@m-privacy.de>
In-Reply-To: <84603f88-a5e9-466a-b632-0ba8729c2187@m-privacy.de>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 18 Dec 2024 17:05:20 +0200
Message-ID: <CAO8a2SgpMBW0pXZGUdmATLJMhKB39xWLoa8+T_ovLmipAW8VEw@mail.gmail.com>
Subject: Re: Clients failing to respond to capability release with LTS kernel 6.6
To: Amon Ott <a.ott@m-privacy.de>
Cc: ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Amon,
We are already investigating similar issues, if possible two things
might be of help to use.
1. A recreate test scenario
2. A dmesg log if it contains any errors or warnings.

LTS kernels I assume ubuntu? Knowing the exact kernel version would
help bisecting and finding what caused the degradation.

On Wed, Dec 18, 2024 at 11:39=E2=80=AFAM Amon Ott <a.ott@m-privacy.de> wrot=
e:
>
> Hi!
>
> After changing client systems from kernel 5.10 to 6.6 about a year ago,
> we got many of these messages:
>
> Health check failed: 1 clients failing to respond to capability
> release (MDS_CLIENT_LATE_RELEASE)
>
> Recent MDS changes provide a workaround that at least avoids going
> read-only, but it can still lead to hanging Ceph requests.
>
> Kernel 6.6.55 brought fixes that seemed to help a bit, this one might be
> relevant:
>      ceph: fix cap ref leak via netfs init_request
>      commit ccda9910d8490f4fb067131598e4b2e986faa5a0 upstream.
>
> However, with 6.6.58 we still got some of these messages and hanging
> requests. There seem to have been no relevant Ceph fixes after that, so
> we have not dared testing since.
>
> As these clusters are in production use, we switched back to kernel 5.10
> again, which has been working with Ceph without problems for some years.
> All our tests show that this problem is only related to the kernel
> client version, it happens with various Ceph server versions from 10 to 1=
9.
>
> We would appreciate if someone with deeper knowledge of the Ceph kernel
> client could look into this problem again.
>
> In January (after the Xmas break) we could test on affected customer
> systems with any proposed fixes. The new LTS kernel 6.12 would be fine
> for us, too. It does not seem to have any relevant Ceph changes either,
> though.
>
> Thanks for your work!
>
> Amon Ott
> --
> Dr. Amon Ott
> m-privacy GmbH           Tel: +49 30 24342334
> Werner-Vo=C3=9F-Damm 62       Fax: +49 30 99296856
> 12101 Berlin             http://www.m-privacy.de
>
> Amtsgericht Charlottenburg, HRB 84946
>
> Gesch=C3=A4ftsf=C3=BChrer:
>   Dipl.-Kfm. Holger Maczkowsky,
>   Roman Maczkowsky
>
> GnuPG-Key-ID: 0x2DD3A649
> Amon Ott
> --
> Dr. Amon Ott
> m-privacy GmbH           Tel: +49 30 24342334
> Werner-Vo=C3=9F-Damm 62       Fax: +49 30 99296856
> 12101 Berlin             http://www.m-privacy.de
>
> Amtsgericht Charlottenburg, HRB 84946
>
> Gesch=C3=A4ftsf=C3=BChrer:
>   Dipl.-Kfm. Holger Maczkowsky,
>   Roman Maczkowsky
>
> GnuPG-Key-ID: 0x2DD3A649
>
>


