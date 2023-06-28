Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB73740CE9
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Jun 2023 11:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjF1J1s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Jun 2023 05:27:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235627AbjF1I6a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Jun 2023 04:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687942663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pe+jjfKxz11wLuvZzVRewm2FezAhqYeJMcaF+IP9YH8=;
        b=gpwQIxsqqwmjpIfIap7c/2pEcWvX5ItFDO15I4N4g4cXi/LzxL9e3nNbzKfQvgl3T0jV85
        QA2SbQVTDALqnGXQB0xAqP7+qZhUzYklFGN0yMsunJD9Rp2G5nE1dutlgYZdWL7Ro5p1AQ
        Wv/8Ycf++WqjtLQjqIkrHrMYikwcS4I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-YRmIZTSZOx238uf3rCAVwA-1; Wed, 28 Jun 2023 04:57:41 -0400
X-MC-Unique: YRmIZTSZOx238uf3rCAVwA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-97542592eb9so318013366b.2
        for <ceph-devel@vger.kernel.org>; Wed, 28 Jun 2023 01:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687942660; x=1690534660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pe+jjfKxz11wLuvZzVRewm2FezAhqYeJMcaF+IP9YH8=;
        b=IiVTY00jBey+wPrB7cKcoSJR9HZiuaSM+mwBeMMs+wKzHiYR6I77YbwHItoaj4HMAQ
         HZa2qU6SnMyGdLs31Z6jR3kbn3Ne1EIGSbuBGKx2cWJvhjYWYjV70PZBXGxJcILRGy/f
         PIzvBUSOgGqWP8zd557dqnuZfExTuymy1Fsw1Fb9ekM7xMcSagzfKzu9T6u8TLGYtROt
         EeyRxslnfqFhVjv+5d2OckvDgYzYx1my+XkR/ou/nDgk6PJbFLniCrQidywYUvdVNIj3
         R5xv5zhWLHaV7CfgHh52qGdKQUdfrd2tqABstug6SO0ZySjLFqOjJoaO7s7jqtxh7bFv
         tvzw==
X-Gm-Message-State: AC+VfDwFIFhu3gU/j8lRVV4leLvubxUb9kn9kRMlvwlHV9j09tJJDdKH
        gMRu5VvkUkM02bQH2MgHn1n14w+Fhgx26XQvb350DzLYahf/Tos3cdtwRWW7OWrvrYFRsUZorNh
        mSJtsK1uPCa+pHsS3p50GHiKBFxAE2r/Qa1FG0Q==
X-Received: by 2002:a17:906:7ce:b0:98d:4000:1bf9 with SMTP id m14-20020a17090607ce00b0098d40001bf9mr14076796ejc.65.1687942660552;
        Wed, 28 Jun 2023 01:57:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7C28t1OVHXAkRO7tKFv1yONqy8s0GBAmrR2XaJybhPqyMVrBEApAGlqbTyQJr0fvlc4rnOpXpNGgqiEZ9wh7g=
X-Received: by 2002:a17:906:7ce:b0:98d:4000:1bf9 with SMTP id
 m14-20020a17090607ce00b0098d40001bf9mr14076782ejc.65.1687942660267; Wed, 28
 Jun 2023 01:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230627235709.201132-1-xiubli@redhat.com>
In-Reply-To: <20230627235709.201132-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Wed, 28 Jun 2023 14:27:04 +0530
Message-ID: <CAED=hWDrnyMZXuVhsjWTnfpGza5YLWz3qkfi8cKu4HMTPnoa_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: don't let check_caps skip sending responses for
 revoke msgs
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Wed, Jun 28, 2023 at 5:29=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If a client sends out a cap-update request with the old 'seq' just
> before a pending cap revoke request, then the MDS might miscalculate
> the 'seqs' and caps. It's therefore always a good idea to ack the
> cap revoke request with the bumped up 'seq'.
>
> Cc: stable@vger.kernel.org
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> URL: https://tracker.ceph.com/issues/61782
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Rephrased the commit comment for better understanding from Milind
>
>
>  fs/ceph/caps.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 1052885025b3..eee2fbca3430 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3737,6 +3737,15 @@ static void handle_cap_grant(struct inode *inode,
>         }
>         BUG_ON(cap->issued & ~cap->implemented);
>
> +       /* don't let check_caps skip sending a response to MDS for revoke=
 msgs */
> +       if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_REVOKE) {
> +               cap->mds_wanted =3D 0;
> +               if (cap =3D=3D ci->i_auth_cap)
> +                       check_caps =3D 1; /* check auth cap only */
> +               else
> +                       check_caps =3D 2; /* check all caps */
> +       }
> +
>         if (extra_info->inline_version > 0 &&
>             extra_info->inline_version >=3D ci->i_inline_version) {
>                 ci->i_inline_version =3D extra_info->inline_version;
> --
> 2.40.1
>


--=20
Milind

