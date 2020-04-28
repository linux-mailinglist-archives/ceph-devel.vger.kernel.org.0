Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6431BBDCF
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Apr 2020 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgD1Mot (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Apr 2020 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726678AbgD1Mot (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:44:49 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEFDC03C1A9
        for <ceph-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:44:47 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n143so21556098qkn.8
        for <ceph-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQPB7c1c2PchpfqRs8MhokLhEPv8eAkEwKvgHIbvvlE=;
        b=naWoKz/u1lKHZCKfuLSUdrazVFTsIa3Is/0vGaJWKSF14RjTsABLe7iUjkRUY2lax8
         JvfMdUv8MWWfgCntu41lnjM0MeX8RRVU+2iQwFPKpnYGkKBK/vFKaJ/Kczat+DDojp4f
         qNOd8D4xuIzgtmlhh99oX8C6EaR7PxoOatdEn81ZYaD0czxSVuXQgPJlZrz1t2IBqZ3L
         Knp51sIydPeUaFBXLTkPf5caqVrY4+hxN8+xjLxKqAuHzmxW81CTf6dR7WkZlZHCvUU7
         QBrIMLB46BSZP6RCsop3Ntfr1ukApoWjoHNXwhMJCNLZ6wOGxDoNrrxDX8yFsww6LI6W
         ZWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQPB7c1c2PchpfqRs8MhokLhEPv8eAkEwKvgHIbvvlE=;
        b=cdyQb33BrlnCATscv66ivAhjAeAKdyq9ctrgr1iCUaawU8h5oqZsb/pL2gyCBGr93G
         LPe3Rg7E9D98drtgYjKFvlmbBpJGHMNHzJD2Pex7ArbtCa6ffLYOzV7oIMaWebV2gRVe
         agafeDyk1usQ79digLw1kGgCv8LDkBr5KpE+M4tiM9GSFTW61JX9Isn6/V8+746bZjjP
         aEtIe3RRAmMQVqdmcrkYG1dhIcMeCNIBftkXfIKJwUMmAP/nd6jRzvYuxNAXjmIwshB2
         yKV9jwHjE2BmsH/xuQfymHAxn/NVJsBXJLy/IAo1od/ER7+MQeH5wLCcfi9D7l5kGetB
         a7gw==
X-Gm-Message-State: AGi0PuZTmnvzsoDVmMYy1ZVTKmJIv+1/HgREFQQCy0p1u7+jbIblLcb6
        lUJNAv8BkTSH9sJWkfS4mMi/cZjkBSAKSZaFLNX+l7GPyoQ=
X-Google-Smtp-Source: APiQypLtF9/HLnTefGofvLhWEkCgZI4uoi2cg8w9FfJ+UpsC1DuW2qzK4lHrfk8Nf7QAG9NFuTjYdLTo9znOaMvu1LM=
X-Received: by 2002:a37:414a:: with SMTP id o71mr27136184qka.141.1588077886920;
 Tue, 28 Apr 2020 05:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <1588023986-23672-1-git-send-email-edward6@linux.ibm.com> <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
In-Reply-To: <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 28 Apr 2020 20:44:35 +0800
Message-ID: <CAAM7YAmBrYhsoBvm3yH4734y2nY2HNUXe9=6AFwk5m3bNG5rEA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix up endian bug in managing feature bits
To:     Jeff Layton <jlayton@kernel.org>
Cc:     edward6@linux.ibm.com, ceph-devel <ceph-devel@vger.kernel.org>,
        Ulrich.Weigand@de.ibm.com, Tuan.Hoang1@ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Apr 28, 2020 at 8:23 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-04-27 at 23:46 +0200, edward6@linux.ibm.com wrote:
> > From: Eduard Shishkin <edward6@linux.ibm.com>
> >
> > In the function handle_session() variable @features always
> > contains little endian order of bytes. Just because the feature
> > bits are packed bytewise from left to right in
> > encode_supported_features().
> >
> > However, test_bit(), called to check features availability, assumes
> > the host order of bytes in that variable. This leads to problems on
> > big endian architectures. Specifically it is impossible to mount
> > ceph volume on s390.
> >
> > This patch adds conversion from little endian to the host order
> > of bytes, thus fixing the problem.
> >
> > Signed-off-by: Eduard Shishkin <edward6@linux.ibm.com>
> > ---
> >  fs/ceph/mds_client.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 486f91f..190598d 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3252,7 +3252,7 @@ static void handle_session(struct ceph_mds_session *session,
> >       struct ceph_mds_session_head *h;
> >       u32 op;
> >       u64 seq;
> > -     unsigned long features = 0;
> > +     __le64 features = 0;
> >       int wake = 0;
> >       bool blacklisted = false;
> >
> > @@ -3301,7 +3301,7 @@ static void handle_session(struct ceph_mds_session *session,
> >               if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
> >                       pr_info("mds%d reconnect success\n", session->s_mds);
> >               session->s_state = CEPH_MDS_SESSION_OPEN;
> > -             session->s_features = features;
> > +             session->s_features = le64_to_cpu(features);
> >               renewed_caps(mdsc, session, 0);
> >               wake = 1;
> >               if (mdsc->stopping)
>
> (cc'ing Zheng since he did the original patches here)
>
> Thanks Eduard. The problem is real, but I think we can just do the
> conversion during the decode.
>
> The feature mask words sent by the MDS are 64 bits, so if it's smaller
> we can assume that it's malformed. So, I don't think we need to handle
> the case where it's smaller than 8 bytes.
>
> How about this patch instead?
>
> --------------------------8<-----------------------------
>
> ceph: fix endianness bug when handling MDS session feature bits
>
> Eduard reported a problem mounting cephfs on s390 arch. The feature
> mask sent by the MDS is little-endian, so we need to convert it
> before storing and testing against it.
>
> Reported-by: Eduard Shishkin <edward6@linux.ibm.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a8a5b98148ec..6c283c52d401 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3260,8 +3260,7 @@ static void handle_session(struct ceph_mds_session *session,
>         void *end = p + msg->front.iov_len;
>         struct ceph_mds_session_head *h;
>         u32 op;
> -       u64 seq;
> -       unsigned long features = 0;
> +       u64 seq, features = 0;
>         int wake = 0;
>         bool blacklisted = false;
>
> @@ -3280,9 +3279,8 @@ static void handle_session(struct ceph_mds_session *session,
>                         goto bad;
>                 /* version >= 3, feature bits */
>                 ceph_decode_32_safe(&p, end, len, bad);
> -               ceph_decode_need(&p, end, len, bad);
> -               memcpy(&features, p, min_t(size_t, len, sizeof(features)));
> -               p += len;
> +               ceph_decode_64_safe(&p, end, features, bad);
> +               p += len - sizeof(features);
>         }

this one looks better.

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
>
>         mutex_lock(&mdsc->mutex);
> --
> 2.26.1
>
>
