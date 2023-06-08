Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4BF72782E
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 09:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbjFHHIP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 03:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbjFHHIN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 03:08:13 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590849E;
        Thu,  8 Jun 2023 00:08:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5147dce372eso365048a12.0;
        Thu, 08 Jun 2023 00:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686208091; x=1688800091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TY1ji3AQSOIxm2uC9dk9a6bLAcQ52HFr0Kxsg8m8z0Q=;
        b=VEU0nbvgBNTx76i8FNqaTLN2KVEOpTP5yHeiScB6FRDcA03TW/bAiQUd6fcqzYEsTE
         cqdOMWrvyt+iyOEtGJ8ZLCNKZbI55YAS6mrF4OiinuKSDcxDbJFWVQ0GyYUuO1tXxkZe
         hrLtkPHtJGjfJusPHV3pOAr2FQzXB6HB/dAphGH0LT3Zgosbg4H6Aos/P10z+wY8BuxX
         rwncHwxlPg22okwu62dDSnPRG+Dv0ZoovbyAXMuh5xM+osl9Oz97BWKm/7SlwvECViNi
         qOjAh+qwqn1aaAlFKQHg8KH8CN5uRckpvSvkwYxYo9qAWfbyDQxBs/WjX+YXVJvB5gaM
         DbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686208091; x=1688800091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TY1ji3AQSOIxm2uC9dk9a6bLAcQ52HFr0Kxsg8m8z0Q=;
        b=agqQnIWGQVl8MFGeFnTAowldRGPg8Xcv4pxga6kBf6jXT9LaUKAv9Eh6XM5C+vwAOZ
         XcywOhDOBWfJ+3gb6VPMI3seDPoRdcNXz/iZqMcjf7pmDbHVJbYb76fKveZcszzk8Emn
         u9ia7gmEomeVooidMYbi8w8VTGFIae8QxdJjTvkSyg3K2v9XfJYQFYfvj6el6KtBSOkN
         4FW/aT9luC/PoN1Xe33IVZdKnsFXl6GSlYgiab4u3bqkTsDi6UJg2Xc1nvRWEN5Tg2FH
         6sKCOoBwO2XGIhyPBvrm4UGxyvSgH/UyPOAWAULVoXjn4FLyJ6tnrunt4tEuXId4OZF3
         6dUg==
X-Gm-Message-State: AC+VfDz3Cq/F8pF5rHaUloiKxNQHe5/WXwwqEzLw4hw4pAEgsZcUvxw6
        7NiULrT0ZNULlOCMk2lXI3E4SSsEyIWwFquvNto50LWAFLE=
X-Google-Smtp-Source: ACHHUZ5og+jvxnX+oG5FAkk8BjPw0E2u/Z7uHiL9MArHp9cEOcxuuSfvSHhQrcLj9o8btnnY8yzSGzwD/3f4d74zD3o=
X-Received: by 2002:a17:906:9750:b0:973:edba:df30 with SMTP id
 o16-20020a170906975000b00973edbadf30mr9602729ejy.61.1686208090655; Thu, 08
 Jun 2023 00:08:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230607025434.1119867-1-xiubli@redhat.com>
In-Reply-To: <20230607025434.1119867-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 8 Jun 2023 09:07:58 +0200
Message-ID: <CAOi1vP9KjpfNkonSEWSm6+HJwykm6ThHchK9E=MR1zSOjr_v+Q@mail.gmail.com>
Subject: Re: [PATCH v4] ceph: fix use-after-free bug for inodes when flushing capsnaps
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 7, 2023 at 4:57=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> There is a race between capsnaps flush and removing the inode from
> 'mdsc->snap_flush_list' list:
>
>    =3D=3D Thread A =3D=3D                     =3D=3D Thread B =3D=3D
> ceph_queue_cap_snap()
>  -> allocate 'capsnapA'
>  ->ihold('&ci->vfs_inode')
>  ->add 'capsnapA' to 'ci->i_cap_snaps'
>  ->add 'ci' to 'mdsc->snap_flush_list'
>     ...
>    =3D=3D Thread C =3D=3D
> ceph_flush_snaps()
>  ->__ceph_flush_snaps()
>   ->__send_flush_snap()
>                                 handle_cap_flushsnap_ack()
>                                  ->iput('&ci->vfs_inode')
>                                    this also will release 'ci'
>                                     ...
>                                       =3D=3D Thread D =3D=3D
>                                 ceph_handle_snap()
>                                  ->flush_snaps()
>                                   ->iterate 'mdsc->snap_flush_list'
>                                    ->get the stale 'ci'
>  ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
>    'mdsc->snap_flush_list'           will WARNING
>
> To fix this we will increase the inode's i_count ref when adding 'ci'
> to the 'mdsc->snap_flush_list' list.
>
> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2209299
> Reviewed-by: Milind Changire <mchangir@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V4:
> - s/put/need_put/

Hi Xiubo,

The other part of the suggestion was to make it a bool.  I made the
adjustment and queued up this patch for 6.4-rc6.

Thanks,

                Ilya
