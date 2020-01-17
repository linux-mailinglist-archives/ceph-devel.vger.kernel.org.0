Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B020140CF7
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 15:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgAQOrY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jan 2020 09:47:24 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46643 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbgAQOrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jan 2020 09:47:24 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so26285682ioi.13
        for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2020 06:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZaiqccSov/oKr2gYXwRpf1ycspnwvVFt11FEvrR7sbc=;
        b=KUxDB2DT3QvnaeWygrLB68yjox6dzI8XI5c8hFrWbL4I7MwJJnEWdbvJbjRxfTGdnx
         xpksaEg3vEnw0zIfpHU6H5OUivloTduacGr/Lffg0kWqMnYRlp2NCbPTGsZqErCbr/uT
         JSRTCvSAeeLsAWKi8z0EKb6LHGcAEuqPAac/wFr3G9ZwwHOMaKg4uRDoxkmA1NWowT/C
         4ikcvXS+mHcCRV5wxmoqPwcdUD98R218OHY3Zy18dh1gpLQGsklod/NtiT0T1EOPIDyS
         g5fd4yicBmKXOJvaGuNjAaqyFP4D/B2dZ6V5bM85rmaz9MB4Cve2mcPC6ZxAmURSU7s7
         4b1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZaiqccSov/oKr2gYXwRpf1ycspnwvVFt11FEvrR7sbc=;
        b=HsSryCRqBm7C5CnagYyO3hgpP3xeeWQtMDpTI5kCAAv0+IxrXbWuWKWOuuWn3H3e/1
         R0ASF6NG/uyji2IChVWZ49F7yPATAiwK5A/EP5JG+HMFSZmL+vIClnzQiLSkxEaMluHf
         NPgK2MiKwsYAnQ8u6XmUumVo36MgtJtW0i6xUpmCDNEt/Ir/YMSUBq4V2qI1jzWRdfRH
         r9AQtjOt/QAFdYJPBZuwuVBNNIXfmNupzYswGOc/WVwbEcntb7Rk03m7AjiAmo/xoBYZ
         GAV7XJZCyzc8WerT5svx4U8mb5b5ac0IOC0qObecLLIt/fnno8BRSqzGrcY8WbuqZfWT
         ITVA==
X-Gm-Message-State: APjAAAU+v8hIszobAX2sEtWP1/sQHM726tzEX+cCFsof8uLkXBRZzDq5
        enm6A6n8RREkmtpmNwqVJtKQtKNmbL9SPEDlw6wCnUWRB5E=
X-Google-Smtp-Source: APXvYqwO+bWL+vCpXsVApEX97U9JCnSPlDSlmWsZ/mWHhbJKVCoR9SMdfQxdbtXWDnzNfvLnfFtYpfSZnBJaM4hyqyk=
X-Received: by 2002:a6b:4e0b:: with SMTP id c11mr3268452iob.143.1579272443891;
 Fri, 17 Jan 2020 06:47:23 -0800 (PST)
MIME-Version: 1.0
References: <20200115205912.38688-1-jlayton@kernel.org> <20200115205912.38688-9-jlayton@kernel.org>
In-Reply-To: <20200115205912.38688-9-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 17 Jan 2020 15:47:21 +0100
Message-ID: <CAOi1vP_oXUTLfhMU6qWfk9Ha=09BdmwF52MeoytKHQWz+Mfwdw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/10] ceph: add new MDS req field to hold
 delegated inode number
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jan 15, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Add new request field to hold the delegated inode number. Encode that
> into the message when it's set.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 3 +--
>  fs/ceph/mds_client.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e49ca0533df1..b8070e8c4686 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2466,7 +2466,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>         head->op = cpu_to_le32(req->r_op);
>         head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
>         head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
> -       head->ino = 0;
> +       head->ino = cpu_to_le64(req->r_deleg_ino);
>         head->args = req->r_args;
>
>         ceph_encode_filepath(&p, end, ino1, path1);
> @@ -2627,7 +2627,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
>         rhead->flags = cpu_to_le32(flags);
>         rhead->num_fwd = req->r_num_fwd;
>         rhead->num_retry = req->r_attempts - 1;
> -       rhead->ino = 0;
>
>         dout(" r_parent = %p\n", req->r_parent);
>         return 0;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 2a32afa15eb6..0811543ffd79 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -308,6 +308,7 @@ struct ceph_mds_request {
>         int               r_num_fwd;    /* number of forward attempts */
>         int               r_resend_mds; /* mds to resend to next, if any*/
>         u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> +       unsigned long     r_deleg_ino;

u64, as head->ino is __le64?

Thanks,

                Ilya
