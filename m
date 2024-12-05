Return-Path: <ceph-devel+bounces-2248-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 133C09E53DA
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 12:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557461883A0B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 11:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440A31F4279;
	Thu,  5 Dec 2024 11:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idRme8Nh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ED11E282D;
	Thu,  5 Dec 2024 11:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733397896; cv=none; b=U1Wh/6xu90fQl/uW2BiqXspRQ8kwzA+YJryC5mMLJwjuKmxHcxJHJeVdTNiRW2vNs70HXaC8eNzlwUQpohX0Fy4vXBGoXCamJhR2JRE+uUXYrHm0UNqh3QCfsgvuYjPjnJM0NJxAnmu8/JjVIUapEreiajQCjSP8NjVGKhFtnx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733397896; c=relaxed/simple;
	bh=TeZ+L4z4T8oDSEG7S2D9D0VCSvNqmUQTU6VpM5Tp7RQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HANPmRETzXuY7FR3J28ir8itDo1DAJo4UWCqsqnpJrMNYB1tG2FlPWxNi0POsHKgwG7e5vDcRo8d3Vaw/NIkaJF0QvAuMFCJEQfyU/4z3yrdu3JEAU+Ry0V9WQ/mrIngk+dhiFNH9u1INQ57JA/uN3QmNO6EpBLGt4Ai89HzM0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idRme8Nh; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee990ba9d5so568725a91.2;
        Thu, 05 Dec 2024 03:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733397894; x=1734002694; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3b8CDwLKxd9GtZyeopEpifrSDe+9GPqyVH1ezNyx+f0=;
        b=idRme8Nh2av6uxTMo4UTOICmFphenuq+GZs82f1QA4+DHHh4VLQj5ajaCWI6pKBi1L
         1BNFOgot81Jd0lYpSy46Hy0YxOzmqpW27//kROqjVlbWS+mAfMbI7gVP0baof7jJKU6h
         XFBhsHhalpGLtF0a4lREpGLomBrRXh25HSqBshibqrlG5Kooj7rGCPzMQbNbb5D3U5F4
         QOw5K/KTsDv9cfkVzkQ6+FCvlPhMojDQhVM9kaPet9qdUJCYi5NcFNuKlB0IvgvLpU1X
         ZWGnOfBEQPDDIOizGqp52rwlClt+Z/2yD/yq66Nc7rHCjlwq7BAS5g8sD1sV84KoGHjf
         fZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733397894; x=1734002694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3b8CDwLKxd9GtZyeopEpifrSDe+9GPqyVH1ezNyx+f0=;
        b=YC2bmYKa4/xGl7X3qcX2geAe96Pi0En1x1cCpDDOh4gUVkGQf41kl9jo8+YZdHT2D8
         7TMArf0T2Jb5Il17atBuQNonGqyF3lUAdDcjJle4FQEdIUHcF0EQzVF9eURxUhYEHbTx
         ZfcAdp733CCfGBFtc6rE+2KNG3KmPVifdAHDJBXowOwG4AhCIOy+j2SgeKH61rnFRoio
         tQAzZUP7En1abYoub/WnfNcgZaptPPUhI5yjKLybtuB/7sLQaX3064O4DWHeJEV6BM5i
         FGGGQAcjR+skqQiTYxMF4HOomzGaQDSF/ZJYx0eWto2SHYl+Z4iXCOnki3qzNc8GdR9c
         sBUg==
X-Forwarded-Encrypted: i=1; AJvYcCVqWGV3mw7G4q0DdWap5u3BjEZ1VPCQ9yhg1Z+jhXWs4SSO+RFtL03cJFrPzZw5iJqJCAB0m1Jn@vger.kernel.org, AJvYcCWL6wRG+p8NXI7MBc5IMB+RnVkOCsYhAgs2xZHzTSEThrtbxTBzj7o8QHDfrZzwFCLWJnbHhZnlDJ5wlpOZ@vger.kernel.org, AJvYcCXeX5kczo9GZ7A5QE9vn48TFRYdxUQbnChiNk96Mk+Z85VMd+ykvr67YyOriJxydPG2C2x3x6GPzUxr@vger.kernel.org
X-Gm-Message-State: AOJu0YyTv+M7ow8gFSRq9U7mZxKS3If6SilVmJA4Gko6oiun2mHDIYd0
	NkVNkBIKGTk/X7RFGNEPpFfa6IQEmveihh8vLb6nsm81Ug/V6MYU2DyX0v3V4dNkpkXjXlD1eLG
	oFUjzxCKAuuP/W3yIBnLTwa8A9OE=
X-Gm-Gg: ASbGncuOcnbPeNbvg0w19lMNrDrACCgoaNxVfj+7VBK8/5/BZOeYtNIu8FRw+tf4LV0
	grJ4OJd0FCx1ZCr0LF0LktTBxPh+yfOs=
X-Google-Smtp-Source: AGHT+IF1OiLaI0em7K6ZAWY9gJ1Mmh8HrAYy8K5BoVHEhBAm8hsuCdocq4uLc9ryKSWZiEUdNWLJg3nyqlhuuGp2XHQ=
X-Received: by 2002:a17:90b:3b8b:b0:2ee:cd83:8fc3 with SMTP id
 98e67ed59e1d1-2ef0127967dmr13952696a91.37.1733397893733; Thu, 05 Dec 2024
 03:24:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
 <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com> <CAKPOu+-rrmGWGzTKZ9i671tHuu0GgaCQTJjP5WPc7LOFhDSNZg@mail.gmail.com>
In-Reply-To: <CAKPOu+-rrmGWGzTKZ9i671tHuu0GgaCQTJjP5WPc7LOFhDSNZg@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 5 Dec 2024 12:24:42 +0100
Message-ID: <CAOi1vP-SSyTtLJ1_YVCxQeesY35TPxud8T=Wiw8Fk7QWEpu7jw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Alex Markuze <amarkuze@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 9:32=E2=80=AFAM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Fri, Nov 29, 2024 at 9:06=E2=80=AFAM Max Kellermann <max.kellermann@io=
nos.com> wrote:
> >
> > On Thu, Nov 28, 2024 at 1:18=E2=80=AFPM Alex Markuze <amarkuze@redhat.c=
om> wrote:
> > > Pages are freed in `ceph_osdc_put_request`, trying to release them
> > > this way will end badly.
> >
> > Is there anybody else who can explain this to me?
> > I believe Alex is wrong and my patch is correct, but maybe I'm missing
> > something.
>
> It's been a week. Is there really nobody who understands this piece of
> code? I believe I do understand it, but my understanding conflicts
> with Alex's, and he's the expert (and I'm not).

Hi Max,

Your understanding is correct.  Pages would be freed automatically
together with the request only if the ownership is transferred by
passing true for own_pages to osd_req_op_extent_osd_data_pages(), which
__ceph_sync_read() doesn't do.

These error path leaks were introduced in commits 03bc06c7b0bd ("ceph:
add new mount option to enable sparse reads") and f0fe1e54cfcf ("ceph:
plumb in decryption during reads") with support for fscrypt.  Looking
at the former commit, it looks like a similar leak was introduced in
ceph_direct_read_write() too -- on bvecs instead of pages.

I have applied this patch and will take care of the leak on bvecs
myself because I think I see other issues there.

Thanks,

                Ilya

