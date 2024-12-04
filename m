Return-Path: <ceph-devel+bounces-2243-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0089E3AD3
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 14:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04FCFB2F644
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 13:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767591B87F7;
	Wed,  4 Dec 2024 13:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="DPWSlsl7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983881B4130
	for <ceph-devel@vger.kernel.org>; Wed,  4 Dec 2024 13:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733317552; cv=none; b=iv5cRqQu8oijyDKFBqPzlvjRTh8CJNjWPl+iJkKgxWWUvLRDW7+M6n+qdBfFZBJIRTasO+9ie7/5Mqn/rg7n5IwxPfi9UtVkYrMWtZmYa3CI0i42Af+RPxFYjApcyG6OxThxS3nam3E65bnqX7q7R5dVOzSOt1YkyUJg8qi48VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733317552; c=relaxed/simple;
	bh=Z3EENbcgyMum84QzWlYJALT23zS7loMokMBszOJOSX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BGXNve0/dIrP0OUiTHjoW4y1N9FOC8OTuwcc5oo/Btqr/dA8nq6D5HDp7nq8inyy/dvUm2HxARbpz4iwFVWUUr2dzvKhrc3TySpbMsMCTDwOxtR6DVHj6tQzL5e8kJYB7o1etu/uOl5bhpIyfaw+869s2NuIWb8X9/UlNfqtbdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=DPWSlsl7; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d0bf77af4dso5911588a12.3
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2024 05:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733317548; x=1733922348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3EENbcgyMum84QzWlYJALT23zS7loMokMBszOJOSX4=;
        b=DPWSlsl7sjY4NmrKmvWt3tRZMtRWqkcyrBKrUYMvEta/xr1bWiKbRyJyhdpZGSuEHD
         ewcejePyZq9mHxYJ5QwjPWba/yFpO2eudzyONjs+nvbiET5O+sDO737PUxdRlkZYKDbo
         RHK2eA3TY83w2JitClwhGvhkHQbpOsV0eWsZa2Hm5NuEeUB7aLP4QYitiqswC6H42Ft0
         mSFmlcT64FSJ3rXwqxmh1o5HehBmPRtJKwdmNlS3ZkhRMJvcfOmhpjsfksxwFJFlULzF
         pqxS9XXvK7fRp4nuB1J8yboy4QHIHWWYO0V6U8WGuN31wkxvQCbIcJQTv9HwRLklM2Tr
         yhvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733317548; x=1733922348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3EENbcgyMum84QzWlYJALT23zS7loMokMBszOJOSX4=;
        b=iPncj+5Ft3QlkUiZPPzeqiuOl8MaQZEekQgichTkrFo3Q2U02eKM3QLsL4r5JpH+MQ
         14u6VRATf2FICkESmfutOTyic+e8On5/Zj9RzxbehtpnQYjHzmwJ7GrCnj3MVZK7gzDD
         B+VTALk0Fsy8QpOpjmbj7P4gK8DxtlkOcXSOnfRd/PWn43bSS3LoQ65YwgHUEuxbi4zo
         j40Jv5F8m1uWv5x6wvifKC30y0OKeHxl//L4D5DVWHGdW6xzmFr1DiYoos636ecDmkW7
         otHb1Wjn21VIQug83e5YtaLZbL1eCePdiohrEIUNGQOp9vK+VTEOIKTLbXOtGfUO1N+0
         uJAA==
X-Forwarded-Encrypted: i=1; AJvYcCWwhz+fVOsEVuNMBjMqLmPAeROFDMaJVNjyX7Bh+4E4ARwv3dS+f9N1EQwAuPGU+3Axx/kCbOqJRp5e@vger.kernel.org
X-Gm-Message-State: AOJu0Yya6jydv44grwI9G4M6C6Wa0tFeM8G/hoFJlf8nJG+bzpDsLq5o
	0aJq/fgKnzNDK0zYdiVuwGoEHS8ME155lEyG1VsGzu6XmliRb+Jw9541/GwOjYdGUB7KqyP7tZX
	+plJsPPxWkSq89SIOEL0wbtM6tQJ+kfaCxBE8tA==
X-Gm-Gg: ASbGncuZZsDhi2Np/Mg95m5p/QdCGJlThTeYwP996M5YjL5PJ6ZprNPQ4UP4DDjMlBP
	LmvzG/FRJH2d2XEmTPTWdybkTPkaAZLUViCPMRuwU2nep9LIFhTcUfU6U9TDB
X-Google-Smtp-Source: AGHT+IGrdr9TGaSHAfS1s7UDwKK36JSpdSVugCVWYYvYdWQLSIIW7IxynDRCS9finSrEfHe9b0yvURkSkUzxde1WavQ=
X-Received: by 2002:a17:906:1ba9:b0:aa5:3853:553c with SMTP id
 a640c23a62f3a-aa5f7f4ae96mr404733366b.53.1733317547869; Wed, 04 Dec 2024
 05:05:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
 <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
 <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
 <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
 <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
 <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com> <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
In-Reply-To: <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 4 Dec 2024 14:05:36 +0100
Message-ID: <CAKPOu+9vUdU8jjdEi76z847JGh5XU1AR93HXuRMv3=D8Jn4i2A@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Alex Markuze <amarkuze@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 1:51=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> w=
rote:
> It's already in a testing branch; what branch are you working on?

It is? Which one? I checked
https://github.com/ceph/ceph-client/commits/testing/ and it's not
there. This is the repository mentioned on
https://docs.ceph.com/en/latest/dev/developer_guide/testing_integration_tes=
ts/tests-integration-testing-teuthology-kernel/

