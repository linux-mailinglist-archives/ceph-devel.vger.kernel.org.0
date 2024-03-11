Return-Path: <ceph-devel+bounces-969-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6516877AB9
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Mar 2024 06:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81C8D281032
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Mar 2024 05:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF48AAD55;
	Mon, 11 Mar 2024 05:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTgqH1AO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3F6101C2
	for <ceph-devel@vger.kernel.org>; Mon, 11 Mar 2024 05:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710135775; cv=none; b=V4V7x3IhaMaxMP6c2b5+ypxxdhiNqpiGCnyLyEPGny8uwZAc3f8keq4Dx7m+kWSS6+P96AP9+nHywRDCrcAEkLoI+fq760GfhJq8n7DRJfCj7T8v6BlcOqmB674cS38kfGCB9+hmLaYfajWErPbJv5P+omJjTJ4YNJTn7owuO2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710135775; c=relaxed/simple;
	bh=/I1znDggn8X3+5HB6zyYe0Cd5VhGijeQUVoYU9ytNHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VPR1+foztcE8aYmNMglhwmkUr4Kva0lJ/X87QexcWmPHGLAwQr5t3B5nA8N/USn3QBDxAaUWDCm7feeEtqrwFSEHQOzYuq1hUMExJBN21EmDfb/Sp6rQuitOYIdYtbexvsspJuqk9KJO/2zBauGE14pMtk9TE/cqaUQ4y5BTpL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTgqH1AO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710135772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUxOxiDP3pi+dVmNq2/k2sMaLre1Ve9BLVUsaTmZUtw=;
	b=jTgqH1AOev+K1cdjgF5XxQYPOgF05Fs7s8Kzt8TcFX5cRDkDZOVIu9UOk0b1yJq8gjX87h
	6ovhgof+uS2ouuXSoXtxnZsusB6avON5YiczVeGtvulhJhHgeLDr2JdCgTAt8gvsfAHEmh
	5TxAtV5TI50DmAJFALDyAc1BS+Y1pdI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-izAPJfSzP1eSLs4b2FA5Sw-1; Mon, 11 Mar 2024 01:42:50 -0400
X-MC-Unique: izAPJfSzP1eSLs4b2FA5Sw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a45acc7f07cso209573266b.2
        for <ceph-devel@vger.kernel.org>; Sun, 10 Mar 2024 22:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710135769; x=1710740569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUxOxiDP3pi+dVmNq2/k2sMaLre1Ve9BLVUsaTmZUtw=;
        b=BTm77Phnc/yNkaLjEIxnbrEp6AvtBIthjlxN86f8xvWN9R4KFyu/N/Yw1F4++bvwG6
         QL94Y3QTJ0IuqFfAtnFI2LXi2S/1DEYDDU5W/yhXSqYwRzAb8I1VwLilBrbnoVPxX7D0
         1Q2OFlFdayRbamHFgumuQZ8PTg2veusAvRxFBCi+iQeW2snym9VT56Y3Q6q7uvoRBW96
         wrabBLHrjCc8Gy3595CajYTE3qQzu4WUqua8nAVsU2S+F1WfT3f6o/eR8IEVsLTVM5js
         jHUuFLJHjZlhSNg+cyRT3AGceuYCX/WiexGPMNfwX9o1dGihfqNmgSFtqEjupQ8PWmV9
         TR4A==
X-Gm-Message-State: AOJu0Ywkgk+H4GTbERoaXy9ITdVZIIdz4GW8tYrYLNygFChQ+UL1BmEB
	XmaO8D6qr56LalApAJJReppi27DDrXqHdrs7HhRfQTIu3ose8HAQek+uXYyG0mhcTtvR9/6pQ1q
	VP80/wBldRmP0hJSSyvL7b/2ZSN+Mi3TWWFN3uKAtLIc1cjvU0MfWfNWUwb1/W1rTXekiHS9Pbl
	X/JfdF5aaih7T17nhJbnDMGHqkbCvVCw9HuQ==
X-Received: by 2002:a17:907:c242:b0:a45:fa86:dddb with SMTP id tj2-20020a170907c24200b00a45fa86dddbmr4833007ejc.12.1710135769568;
        Sun, 10 Mar 2024 22:42:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCLuB9L/UB6f0yBk9p5rFSXUG1zGKfHyoAI4YowRH5VwedHgBOKTsU+1/hzlxokb/KJzG4PY+o/jhqH1tn+Bg=
X-Received: by 2002:a17:907:c242:b0:a45:fa86:dddb with SMTP id
 tj2-20020a170907c24200b00a45fa86dddbmr4832998ejc.12.1710135769292; Sun, 10
 Mar 2024 22:42:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227072705.593676-1-xiubli@redhat.com>
In-Reply-To: <20240227072705.593676-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Mon, 11 Mar 2024 11:12:12 +0530
Message-ID: <CACPzV1nBgM8xxfVY04M4AeTCyE3Lofw-oCnfkeo=cJEX3vrkgA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] ceph: check the cephx mds auth access in client side
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 1:04=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The code are refered to the userspace libcephfs:
> https://github.com/ceph/ceph/pull/48027.
>
>
> V4:
> - Fix https://tracker.ceph.com/issues/64172
> - Improve the comments and code in ceph_mds_auth_match() to make it
>   to be more readable.
>
> V3:
> - Fix https://tracker.ceph.com/issues/63141.
>
> V2:
> - Fix memleak for built 'path'.
>
>
> Xiubo Li (6):
>   ceph: save the cap_auths in client when session being opened
>   ceph: add ceph_mds_check_access() helper support
>   ceph: check the cephx mds auth access for setattr
>   ceph: check the cephx mds auth access for open
>   ceph: check the cephx mds auth access for async dirop
>   ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
>
>  fs/ceph/dir.c        |  28 +++++
>  fs/ceph/file.c       |  66 ++++++++++-
>  fs/ceph/inode.c      |  46 ++++++--
>  fs/ceph/mds_client.c | 270 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/mds_client.h |  28 ++++-
>  5 files changed, 425 insertions(+), 13 deletions(-)
>
> --
> 2.43.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


