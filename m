Return-Path: <ceph-devel+bounces-2322-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A266A9ECA9B
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 11:49:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76F8D1886871
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 10:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CB3239BA1;
	Wed, 11 Dec 2024 10:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJVsM/PV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9768D239BA6
	for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733914154; cv=none; b=FyiOIUEzAJY4bb4XJV6gYZAsVhNxnpigWPDx0hbPLBr/mXcW/bBodSKISfIRXuBp23BLCBqiApoI8erTB7vDqW3MrbXRbZ37K0SY+PUIejwqyUT/AQRGbzarblo+iPstrocUf7tPLWa4Th5dNW4cH3SigEp3/v7IN2nddc3pC+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733914154; c=relaxed/simple;
	bh=VF3J8rZVuEB+SGMA7k1N6HW5V4q+MqnBm02NVEhM1hE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aSI9E86IjDq8ffnXhxps3+NTy5AD9ZfpRAboH9FZrwxa/7wOFiZz+AWyJKJtrzRu1DHrg2zV2VKYCdRonIebkM/CAln7Xp3fvn8UcHv5xAdNDgfrWK10YJuOK/tA5b36JTJyhZAAEumtNmIRIwPpPQQf6plraLiOonctWOnUD84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJVsM/PV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733914151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF3J8rZVuEB+SGMA7k1N6HW5V4q+MqnBm02NVEhM1hE=;
	b=XJVsM/PVlKN8lNWXbrPIU5/B6My/9zsbjOL8JeyXBL5V5ukIuBJsV6ZPBuK3IRkiW9g8TO
	129YM171QqpspxsD1dRoGdxeFglbcTgkq8cQtnXC6J2xu5+vUnaQMBtz2xZXWQPBWWnknv
	INSJrzQ6+UUE/nUr6Lvy2tqGSVvtByU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-61-8A6nsLWdNCqgX-TlxxhKdA-1; Wed, 11 Dec 2024 05:49:10 -0500
X-MC-Unique: 8A6nsLWdNCqgX-TlxxhKdA-1
X-Mimecast-MFC-AGG-ID: 8A6nsLWdNCqgX-TlxxhKdA
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa634496f58so191035066b.2
        for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 02:49:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733914149; x=1734518949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VF3J8rZVuEB+SGMA7k1N6HW5V4q+MqnBm02NVEhM1hE=;
        b=ayXaONk+lUA3Z+u3EVvO0VtdPzEfTQoXqhZ/N8foO3jmGKuPyPYRzA7aLOjCYRvtsQ
         lFKGjpgxfpqfjyAcyoq/4NJWhkxhlUPKcEd1ix80CZ/S9f6eeuqF7qAWrc6FfIlDnR1z
         VAgktIjSPIfA7RRYTygFWcwVto0tvgndtgbgDaCggAPaOz0eTzDVj4OozrOSrlkKBCBk
         djX7+D71FdmHDyh2Gzg9zItTucDYsFyLRxKk1wz5m/jok6BoWd6GDrPV+h7bxp5ZpSr+
         6nPFOsdyhKOsPOnezSfcWIptW6I653r1yoSaeto9XkEWeqv5UmHQmWZ/iko/kbFe/gGy
         0jeQ==
X-Gm-Message-State: AOJu0YwowWatvYnWXbyqOiyW8QBbaNDwKJLegDUnqcE3ZdFqE/pU0ozd
	tHnl7skzdvIicSPHlU59Id1kCxljHsklnj7lXOzW9hOd7hgOWuSxbW19wC2WQWLy7vo5ycjarI0
	SspbazW2gkc/OxqhlWCNs6GN1JK2NyGa6ktXoVmuEEkT3OMFoWhXzHJUcSSfwLEIEy2llWJCYUV
	2dHvpAzFyfWwOEbXBbKd4s3TQxtsag6rWcOQ==
X-Gm-Gg: ASbGncvoYHBYGFW3giBJwuryEyFfMYfAt78xg9aTM1hcx3sQqJNpz3UddiewViHP5Ik
	866oYWyRY/FrppFokikew2Z0JYWX8aEfmFb8=
X-Received: by 2002:a17:906:8454:b0:aa6:9461:a17e with SMTP id a640c23a62f3a-aa6b13c86f8mr205351666b.40.1733914148695;
        Wed, 11 Dec 2024 02:49:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEX5UlLJwbQxwZCOn+N8EVyI7UZuxqq0/KzwWgkkS6PmtdGb2a+AsFRIvKwOkiMLG6op8O8w7J45hW4TRDjQHM=
X-Received: by 2002:a17:906:8454:b0:aa6:9461:a17e with SMTP id
 a640c23a62f3a-aa6b13c86f8mr205349766b.40.1733914148216; Wed, 11 Dec 2024
 02:49:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACKp3f=17HPw=aB1Di455buZriGTbErzu4ZVe48EK+vRNcTEdw@mail.gmail.com>
In-Reply-To: <CACKp3f=17HPw=aB1Di455buZriGTbErzu4ZVe48EK+vRNcTEdw@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 11 Dec 2024 12:48:57 +0200
Message-ID: <CAO8a2SgkEcRFFuHHoQzQ5z9VPG7OPVhJ+cYBAW3vfWEsHrmXGg@mail.gmail.com>
Subject: Re: Calling iput inside OSD dispatcher thread might cause deadlock?
To: tzuchieh wu <ethan198912@gmail.com>
Cc: ceph-devel@vger.kernel.org, ethanwu@synology.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ethan.
Do you have a scenario where this can be recreated? I will take a look
at this issue.
Here is the tracker issue to follow this.

https://tracker.ceph.com/issues/69196

On Tue, Oct 29, 2024 at 11:14=E2=80=AFAM tzuchieh wu <ethan198912@gmail.com=
> wrote:
>
> Hi,
> Recently I was running into a hung task on kernel client.
> After investigating the environment, I think there might be a deadlock
> caused by calling iput inside OSD dispatch(ceph-msgr) thread
>
> My kernel cpeh client version is 5.15
> The call stack for the kernel ceph-msgr thread is:
>
> [<0>] wait_on_page_bit_common+0x106/0x300
> [<0>] truncate_inode_pages_range+0x381/0x6a0
> [<0>] ceph_evict_inode+0x4a/0x200 [ceph]
> [<0>] evict+0xc6/0x190
> [<0>] ceph_put_wrbuffer_cap_refs+0xdf/0x1d0 [ceph]
> [<0>] writepages_finish+0x2c4/0x440 [ceph]
> [<0>] handle_reply+0x5be/0x6d0 [libceph]
> [<0>] dispatch+0x49/0xa60 [libceph]
> [<0>] ceph_con_workfn+0x10fa/0x24b0 [libceph]
> [<0>] worker_run_work+0xb8/0xd0
> [<0>] process_one_work+0x1d3/0x3c0
> [<0>] worker_thread+0x4d/0x3e0
> [<0>] kthread+0x12d/0x150
> [<0>] ret_from_fork+0x1f/0x30
>
> And the following messages are from osdc in ceph debugfs
>
> 2774296 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x40002c 92 write
> ...
> 2774578 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774579 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774580 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774581 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774582 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774583 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> 2774584 osd30 4.1ea6f009 4.9 [30,14]/30 [30,14]/30 e18281
> 200006dabea.00000003 0x400014 1 read
> ...
>
> We can see that kernel client has sent both write and multiple read
> requests on object 200006dabea.00000003.
> The iput_final waits for truncate_inode_pages_range to finish which in
> turn waits for page bit.
> From the above osdc and taking a look the code, I think
> truncate_inode_pages_range might be waiting for readahead request to
> finish.
> The client cannot handle the readahead request from osd since the
> ceph-msgr itself is blocking on handle_reply, however.
>
> This following patch solved the problem by calling iput at a different th=
read
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/fs/ceph/inode.c?id=3D3e1d0452edceebb903d23db53201013c940bf000
> but was reverted later because session mutex is no longer held when
> calling iput.
>
> In the comment of the above patch, it also points out:
>
> truncate_inode_pages_range() waits for readahead pages and
> In general, it's not good to call iput_final() inside MDS/OSD dispatch
> threads or while holding any mutex.
>
> Therefore, it looks like calling iput inside OSD dispatch thread is not s=
afe.
> Any suggestion on this issue?
>
> thanks,
> ethan
>


