Return-Path: <ceph-devel+bounces-1834-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 750AA983D1E
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 08:27:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D231C20A47
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 06:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EA56EB5C;
	Tue, 24 Sep 2024 06:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBPLho85"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F62B770F5
	for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 06:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727159231; cv=none; b=thbmqzryDxHdG3w6nKE9F0Qu6u+HUfi45khwlmaXPFnpXZdHRr88tPzCwa5jbtDC5ik067L+ky4fciSAj0jlvHeMy9NS/qgsFEGIXgwe42YnQLM3OoKBjzBxO5qmPlwXKoej1JJatBIHIuL6LcY6WbMpiDDHuzfw7snJuMv6jj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727159231; c=relaxed/simple;
	bh=ToaB1JOiIhxNGlkoTvDW9ZWj+rXQjaYcDC+ZjiRGC/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8EHpMihXlLHL1u2WHZOZJGtWOmNmFWB1KVBhS0sHdU36MAGOo/QxnurpgkdqVAT75BQGYYM1JtqsnhDVrxC1o2IKMFCIZFkZwp08eeBmKKoGDa+UkuClWNbSIFEkGr1YMI9PLDersakxc2tOgl/Rn6pP/wME8MZ6FR440l0Xmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBPLho85; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5d5eec95a74so2366957eaf.1
        for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2024 23:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727159229; x=1727764029; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjOUpCy8WKSzQGYDoSX7l5pAnAQo6+kFqrcb7MHk+AU=;
        b=UBPLho85AQuEvVDhuzeq1boyb0Ty+T/LonxpDetQZd4xbHfFViBXfZIGzq/VJ+4Cjy
         dHYjlUJN8Hv5rB/jk1/ju/P8VkLjl2/NqMuoA9TM8TUYi02wcORQdm2/dtRlEWRzb3Aw
         ZlnkGc/7RcLclHkB+/aT4RQyz+umotVZcKgseDViPBZIsC64wr137d7t7zkHQof2upSa
         N28obwgSf0JohnrGsQsFsPRLcd4Mc+4/9nvSTgx9+2iOEq8RhquozMDHh9t4l2rNB82f
         rh5jf4bdYQcwkGIpzm7D5/hDqeLvjbCGiXQF2rr1p0cLx8ANE+Rsy2kH3X0fjhXXQ7wt
         8jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727159229; x=1727764029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yjOUpCy8WKSzQGYDoSX7l5pAnAQo6+kFqrcb7MHk+AU=;
        b=MG+C0moxMGr/tewAkju984MbCHy1CWR1PeO6uZ5UCafEYl+1rtWVnS5fUPXVPRj7T9
         3JD7tIk26d3SKpppDTdBC2v+b3LmaH+Jrh+63MRdBOmgk97wE2WLD1MuBkASLoV3iE2S
         29/36rD3ImKcX5AvHOl7bll1zIDCdrwOzkuBtF7Ik2h9nh4O/JfubKPQv0XrYh3IThlL
         u88Z0RwVFRy8t/4Bnzc121NjQRQHm8Rzhm2rOn54IUPek2swwuhbvtE3I/k7CsUkMvrE
         XtSae1MjD+40f49kHgVo62eQQqKNNswGhT4pu0/RzcjpR6+QHt5cV5bQfP8tTe6aPq/r
         1+2w==
X-Gm-Message-State: AOJu0Yxm6/DNeBqgD/lhS1yGGKqSozj3HqCXnNE1Y/5F6qPWKPdFV7bZ
	3TrBi7PuVR7rQDISuylhfYmPb3W04lBcMnlt4F83F7Qa35WuGgRDx0xOkEyfqLyEIagHHYsJu2r
	Xzr77THzY+yXrPL0dVmqW6EPKO2A=
X-Google-Smtp-Source: AGHT+IF0pJvTI5aBPGuqHK4+rLGKgtLH1pqkUzRDWSqbmhXtqdDYxdlReWCf1WFRJPrRz+hcRohG2i3nld24Po1RGwc=
X-Received: by 2002:a05:6870:40c2:b0:260:3fb2:b724 with SMTP id
 586e51a60fabf-2803a8e79b4mr6802232fac.46.1727159228932; Mon, 23 Sep 2024
 23:27:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240730054135.640396-1-xiubli@redhat.com> <20240730054135.640396-3-xiubli@redhat.com>
In-Reply-To: <20240730054135.640396-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 24 Sep 2024 08:26:56 +0200
Message-ID: <CAOi1vP9g92tv8sEbFbSkV73PwrqqNNQktcYxUvdwCYBZkhhnsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: flush all the caps release when syncing the
 whole filesystem
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2024 at 7:41=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> We have hit a race between cap releases and cap revoke request
> that will cause the check_caps() to miss sending a cap revoke ack
> to MDS. And the client will depend on the cap release to release
> that revoking caps, which could be delayed for some unknown reasons.
>
> In Kclient we have figured out the RCA about race and we need
> a way to explictly trigger this manually could help to get rid
> of the caps revoke stuck issue.
>
> URL: https://tracker.ceph.com/issues/67221
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 22 ++++++++++++++++++++++
>  fs/ceph/mds_client.c |  1 +
>  fs/ceph/super.c      |  1 +
>  fs/ceph/super.h      |  1 +
>  4 files changed, 25 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c09add6d6516..a0a39243aeb3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4729,6 +4729,28 @@ void ceph_flush_dirty_caps(struct ceph_mds_client =
*mdsc)
>         ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
>  }
>
> +/*
> + * Flush all cap releases to the mds
> + */
> +static void flush_cap_releases(struct ceph_mds_session *s)
> +{
> +       struct ceph_mds_client *mdsc =3D s->s_mdsc;
> +       struct ceph_client *cl =3D mdsc->fsc->client;
> +
> +       doutc(cl, "begin\n");
> +       spin_lock(&s->s_cap_lock);
> +       if (s->s_num_cap_releases)
> +               ceph_flush_session_cap_releases(mdsc, s);
> +       spin_unlock(&s->s_cap_lock);
> +       doutc(cl, "done\n");
> +
> +}
> +
> +void ceph_flush_cap_releases(struct ceph_mds_client *mdsc)
> +{
> +       ceph_mdsc_iterate_sessions(mdsc, flush_cap_releases, true);
> +}
> +
>  void __ceph_touch_fmode(struct ceph_inode_info *ci,
>                         struct ceph_mds_client *mdsc, int fmode)
>  {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 86d0148819b0..fc563b59959a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5904,6 +5904,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
>         want_tid =3D mdsc->last_tid;
>         mutex_unlock(&mdsc->mutex);
>
> +       ceph_flush_cap_releases(mdsc);
>         ceph_flush_dirty_caps(mdsc);
>         spin_lock(&mdsc->cap_dirty_lock);
>         want_flush =3D mdsc->last_cap_flush_tid;
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f489b3e12429..0a1215b4f0ba 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -126,6 +126,7 @@ static int ceph_sync_fs(struct super_block *sb, int w=
ait)
>         if (!wait) {
>                 doutc(cl, "(non-blocking)\n");
>                 ceph_flush_dirty_caps(fsc->mdsc);
> +               ceph_flush_cap_releases(fsc->mdsc);

Hi Xiubo,

Is there a significance to flushing cap releases before dirty caps on
the blocking path and doing it vice versa (i.e. flushing cap releases
after dirty caps) on the non-blocking path?

Thanks,

                Ilya

