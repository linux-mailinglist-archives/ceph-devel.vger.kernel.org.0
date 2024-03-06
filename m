Return-Path: <ceph-devel+bounces-958-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DDD87389D
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 15:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F10F71C20844
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Mar 2024 14:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BDCF131756;
	Wed,  6 Mar 2024 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kBRP9Gik"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D71130E49;
	Wed,  6 Mar 2024 14:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709734396; cv=none; b=lRL2Sszx8qNd6zDX47q1PGWjYHO/TnVqfvILeJl6CdQtTudtD8PtdRvZRUnMCfqflo79XgBIShRUNP+6wbL+H1PS9TEJzcPzFn8nMY404iD4/61DzgVvdvDowM4NRRLKrnHWpeiY391M95VT8/pb9rAn11sYJNrAy5Ii3tk0OB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709734396; c=relaxed/simple;
	bh=It7NICRbL71EELJxllQ0BP1TzJfhsjBT/sz/UMTrHLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W5U/SPy78v2PCr0xagHFY7vQOeyvSczLbte/ESBveO+1OgvTCU/eZMsrRN7O9wIo7wwj2Zh9nq3Ep37e1qqcZhQ8UdnPk4KvzeE5IoBdMtSrp//0d3Wh4aJn5U5zpdc3fWgKmwBFm5uefhEXvBniqiDnrFq8srPd2d11cPgsAwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kBRP9Gik; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-22008177fbeso4101806fac.2;
        Wed, 06 Mar 2024 06:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709734393; x=1710339193; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lDJW5XO0Z8RR5HbABA4SB63Audsmw8maIWzqQ6JX9FI=;
        b=kBRP9GikBg+Y326nkdXOffxVQd0ufjVOyWV3MS3tQhQ5He76kJAuqSxd4AxB45OMH9
         3Bh4Q322RWoesrUD8/iTQKDigoCYogIElneHp5k8z05BOdxyAFkwirei+X0JeGuY55nH
         tBxtKrkrrTVbfpmAbsSgLoBGDyZb2sar6kbAelI0sFR9noMIeHjJOcXq1AoxB2ZbUPeh
         WqDoNlOrZfiLZCesqBWBil4oICwOd1sdtavTFwUXf0wnrmmB4O7ea1V42uyu+KcWa6hd
         mS6ThL9jt/EDBYRu5uH4SQh0d4kB3q0XFMObt3ytSKC0l5il7D+kpLOQjPTLHFXclINa
         i2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709734393; x=1710339193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDJW5XO0Z8RR5HbABA4SB63Audsmw8maIWzqQ6JX9FI=;
        b=JKRXyX2OVav0Qr96SdTRDg2BbJo79+otIw4Xej4GFaUL7ZBYT0ccOq95SffqiHKFop
         rrh7+y3DJ+m2URe9UlrfKiAIO0hc7J8I4HIZs/bB5o5cH4mnYvGV5iCk3ADZV3Y3e+zs
         7q+tOpR8gGA9eZDjHQD8sHv4ay+7v2kdEPGpwPl8qU9voSSiYD70NCiD7PXMkmNQtSXB
         zutv3+XsUU4djS+1IF9kn09TlXkyLyyIIIrKL6lBWKBflZTeJhXj8NOYri5mgORujULz
         VmWNUcH/JSUY+n46SY57OdDsoe0XLXJhY2lqHHloXKWKQw96QdgQiekn97j9i1Eip3bz
         9KXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv7MZg/ymlEyCLk3VWLdqcXiyt6wfZSK/lP3HgH49Y85AVrrKhM/zJLsD1WAO4oFBMJ0RGJnmFBDFC8Cy+hA4chCpSAoIX/MDug1aC1xZGXjufvkaL2bG0JyeNWhnnh94m2w==
X-Gm-Message-State: AOJu0Yx0YoXa+8G1ADUUlIHA5cBJGG/lEIGA0EGO1rj4iNNsYNkN+7bV
	wn/mPUWjEBwyC433s/rqlAtQb3Wn13lw8CkHqOwTWlFoiuPhMdSiwA0u+suA8LQC5fh1zgLfXZ9
	0ac6VhZA/7AMUcsFG6rk2PGq9I2U=
X-Google-Smtp-Source: AGHT+IGRq4721MOAgyQqDuldDgp9kVO2AiMAjdMC1PvozrTc3VkKt+fbB/vvOoSIeP5tofkGCpULrZghcU9z0ejNlWg=
X-Received: by 2002:a05:6871:8a7:b0:21e:3c57:18d4 with SMTP id
 r39-20020a05687108a700b0021e3c5718d4mr5287870oaq.19.1709734393643; Wed, 06
 Mar 2024 06:13:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240306010544.182527-1-xiubli@redhat.com> <87msrbr4b3.fsf@suse.de>
In-Reply-To: <87msrbr4b3.fsf@suse.de>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 6 Mar 2024 15:13:01 +0100
Message-ID: <CAOi1vP_CNhNUZsubd2ytXmqGofMpgnOYVrj-5UErDvWJDK2WCQ@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: init the cursor when preparing the sparse read
To: Luis Henriques <lhenriques@suse.de>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, jlayton@kernel.org, 
	vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 12:24=E2=80=AFPM Luis Henriques <lhenriques@suse.de>=
 wrote:
>
> xiubli@redhat.com writes:
>
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > The osd code has remove cursor initilizing code and this will make
> > the sparse read state into a infinite loop. We should initialize
> > the cursor just before each sparse-read in messnger v2.
> >
> > Cc: stable@vger.kernel.org
> > URL: https://tracker.ceph.com/issues/64607
> > Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available =
on the socket")
> > Reported-by: Luis Henriques <lhenriques@suse.de>
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >
> > V2:
> > - Just removed the unnecessary 'sparse_read_total' check.
> >
>
> Thanks a lot for the quick fix, Xiubo.  FWIW:
>
> Tested-by: Luis Henriques <lhenriques@suse.de>

Thank you for catching this, Luis!  I'm still lacking clarity on how
this got missed, but hopefully the fs suite will improve with regard to
fscrypt + ms_type coverage.

I have staged the fix with a minor tweak to use msg local variable
instead of con->in_msg and reworded changelog:

https://github.com/ceph/ceph-client/commit/321e3c3de53c7530cd518219d01f04e7=
e32a9d23

                Ilya

