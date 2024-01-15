Return-Path: <ceph-devel+bounces-527-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF9982E2B3
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 23:45:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E68A2B22179
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jan 2024 22:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E492A1B5BB;
	Mon, 15 Jan 2024 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQ+wA6Z/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE506FBB
	for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 22:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-598d168f253so1871132eaf.3
        for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 14:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705358707; x=1705963507; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuGYzNz52bOQOr7Gank/AeA+JyLASL2dlbWdFWlHMYg=;
        b=XQ+wA6Z/2BI2YCQq+chIeSkUXVvPUvWtcNg04t7enUauOmZjAtdTfkHvceGUGQw2nV
         PAI6b8d+KLzvmqoDWqbjZtLXAVZL/J2nPTBDm+x+6g4vigf/XLTR3MrtleKB/QNdggQl
         TBPmR1UVOUxv4/T27cK47rS6uZdMX6lXbAd8vZ/ewmzaB0RqX6zdECJsDc4mlsrDqVfl
         p3hAkXnttWCrqfevJA3i07wIRhz063pD8ULSk0anK0j0dK8g+DYShcKWWjVI30tUtCzG
         LiBK8CRntO1RGtsHjPv9JWio+7FjqSXPlYOwSTP67wtmRfF4MqJR4ryaWNvuaz1C9ce5
         PRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705358707; x=1705963507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuGYzNz52bOQOr7Gank/AeA+JyLASL2dlbWdFWlHMYg=;
        b=dlTUcyzTRFFtnXHVh6lUzCBMw4PHb+EGxzWQ+QsN1la72nQtYtn0+l+SsCuTOk6xuv
         d4ZjnoyLiit2SGA1R8pmLx1r62T39FeQOWznHcZCmvwlJ762D0PA58n7uf9uJvNbxzrl
         PiMdOYYzW5nDUoHqFCY4qAH7cOqK3FQdWheoXl5QI3DtBpTEq593xsbgA+l1nbKlTyjs
         RazWn8gNGytX7b3Nh/JWxVt94HKDKSKI1Pxv+P3KTpSNhRzXJajyWc6fZhuBzGAxWrNE
         qot7HNJi22dCvA0ViytIEdhSGxoQSWA99FEww1GdqSv3yB2JFm2vOwhZAcDzsQLeuk+X
         GiHg==
X-Gm-Message-State: AOJu0YySqqxk33WuOxx58syRDzsTTlUVHqKDzwx1JOZ1BQMthsJ9ax2Y
	u6Io6aPEc01csvKEb+suO2U5liH6+l1hW48TQ7Y=
X-Google-Smtp-Source: AGHT+IFqF5wFYvhhxr0Gs6npsaYBj6kjVA7Fr8bewCffiN7rHgN98heiAONSMDllP9KF9dr9VWwHDZDZm0wHJDSRU00=
X-Received: by 2002:a4a:ac89:0:b0:595:518e:be8d with SMTP id
 b9-20020a4aac89000000b00595518ebe8dmr2969523oon.0.1705358707390; Mon, 15 Jan
 2024 14:45:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231025061952.288730-1-xiubli@redhat.com> <20231025061952.288730-3-xiubli@redhat.com>
In-Reply-To: <20231025061952.288730-3-xiubli@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 15 Jan 2024 23:44:55 +0100
Message-ID: <CAOi1vP9OdJsQ+AkJ7c7q6xjbsLE_pfLaiu+fwHCV7CUdp640yw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: add ceph_cap_unlink_work to fire check caps immediately
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2023 at 8:22=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When unlinking a file the check caps could be delayed for more than
> 5 seconds, but in MDS side it maybe waiting for the clients to
> release caps.
>
> This will add a dedicated work queue and list to help trigger to
> fire the check caps and dirty buffer flushing immediately.
>
> URL: https://tracker.ceph.com/issues/50223
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c       | 17 ++++++++++++++++-
>  fs/ceph/mds_client.c | 34 ++++++++++++++++++++++++++++++++++
>  fs/ceph/mds_client.h |  4 ++++
>  3 files changed, 54 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9b9ec1adc19d..be4f986e082d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4790,7 +4790,22 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
>                 if (__ceph_caps_dirty(ci)) {
>                         struct ceph_mds_client *mdsc =3D
>                                 ceph_inode_to_fs_client(inode)->mdsc;
> -                       __cap_delay_requeue_front(mdsc, ci);
> +
> +                       doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
> +                             ceph_vinop(inode));
> +                       spin_lock(&mdsc->cap_unlink_delay_lock);
> +                       ci->i_ceph_flags |=3D CEPH_I_FLUSH;
> +                       if (!list_empty(&ci->i_cap_delay_list))
> +                               list_del_init(&ci->i_cap_delay_list);
> +                       list_add_tail(&ci->i_cap_delay_list,
> +                                     &mdsc->cap_unlink_delay_list);
> +                       spin_unlock(&mdsc->cap_unlink_delay_lock);
> +
> +                       /*
> +                        * Fire the work immediately, because the MDS may=
be
> +                        * waiting for caps release.
> +                        */
> +                       schedule_work(&mdsc->cap_unlink_work);

Hi Xiubo,

This schedules a work an a system-wide workqueue, not specific to
CephFS.  Is there something that ensures that it gets flushed as part
of unmount and possibly on other occasions that have to do with
individual inodes?

Thanks,

                Ilya

