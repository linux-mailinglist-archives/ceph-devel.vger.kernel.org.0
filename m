Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAA0520F42
	for <lists+ceph-devel@lfdr.de>; Tue, 10 May 2022 09:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237577AbiEJIBq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 May 2022 04:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiEJIBm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 May 2022 04:01:42 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7D51F158D
        for <ceph-devel@vger.kernel.org>; Tue, 10 May 2022 00:57:33 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id d22so13399689vsf.2
        for <ceph-devel@vger.kernel.org>; Tue, 10 May 2022 00:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ewp+V6YBSgQesGzvwb38QXjpkBwgAUd2g0TKfXZhAw=;
        b=O+knCANitQv4n5w2ST02j93Tn6XyYSuErZESild3u3iA0sUISBpIqWRO7bTczSpS/T
         yIwQ++a6dr9lgObihIJf/IKfxPNsv7U5Pzm4Xja35Szh/5IzZTpRYN2dH3xW435p4JWd
         45y7ALnnlx2VhjmM4Ww7c7JzzqbJ7HiWmDWdSyLnqFwV19xirCCradbeGEFPyVL21zJ2
         nRtt03u4ZKwv6NggoA4SHxXKP7tYp5R4QLFwff5rn6MA4TiabBBvY3wrIM2617NvcyVU
         S9rMdOmJYrGxCyFFMz4fetaGnInQplWJ1eaegWu1mDQz9PPrE9QJ7O/hK823mg53MeUF
         RKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ewp+V6YBSgQesGzvwb38QXjpkBwgAUd2g0TKfXZhAw=;
        b=cJ5pMHeUIMgR/PYlqj4tCi08VaBox6Z8pz48rGvulEExZDHC7TrIBA9H+1EzBWxtLm
         tggUhrUeSJkIybjlr4HR+F07yvCiXwpq07N3MU93haa9RNJDuDLpma3QtmAYKESWgbVa
         BWjIjW1OToyC2CFRBT55VRZqjAql9w3dO2p15C+KRPqQrMAZ9KI1qVAx5s4QnVNCC4Nx
         XcwJAlLxYd+YPINlBjgNIjZnVDtcTxGqVNs2bHjXONt4fO+NmOSfi9sZN1jIOsPfc8cJ
         X7tSjKnLhSzCT799XugNUtked4COusGvTZQRdaMHSj0Knj2bMvw+RvW0vOdycepbg+Bk
         3yeQ==
X-Gm-Message-State: AOAM531ji1tSBGGnbfKW3sIfAJtZe8Ne4KutopFKFDDaekZXjudJpyMv
        mjGrCDMHIZnB6Riymf1knnQ0HvU4NFiyo63fbgA=
X-Google-Smtp-Source: ABdhPJydnWgLmNRhwanB8oqt70AoEpiXgdv2DokfvrAFGt+ktUhnhzWG9LAX4yKZMAczolICWOcGa/sAn5KqmYtSGfE=
X-Received: by 2002:a05:6102:5113:b0:32d:5899:1aa5 with SMTP id
 bm19-20020a056102511300b0032d58991aa5mr11288425vsb.57.1652169452152; Tue, 10
 May 2022 00:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220506152243.497173-1-xiubli@redhat.com>
In-Reply-To: <20220506152243.497173-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 May 2022 09:58:26 +0200
Message-ID: <CAOi1vP9GHbVDTc3pM2x9HMYmeHWzN5SseESXcczEixxC1XL=Ug@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: switch to VM_BUG_ON_FOLIO and continue the loop
 for none write op
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 6, 2022 at 5:22 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> Use the VM_BUG_ON_FOLIO macro to get more infomation when we hit
> the BUG_ON, and continue the loop when seeing the incorrect none
> write opcode in writepages_finish().
>
> URL: https://tracker.ceph.com/issues/55421
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 04a6c3f02f0c..63b7430e1ce6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>         if (folio_test_dirty(folio)) {
>                 dout("%p dirty_folio %p idx %lu -- already dirty\n",
>                      mapping->host, folio, folio->index);
> -               BUG_ON(!folio_get_private(folio));
> +               VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
>                 return false;
>         }
>
> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>          * Reference snap context in folio->private.  Also set
>          * PagePrivate so that we get invalidate_folio callback.
>          */
> -       BUG_ON(folio_get_private(folio));
> +       VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
>         folio_attach_private(folio, snapc);
>
>         return ceph_fscache_dirty_folio(mapping, folio);
> @@ -733,8 +733,11 @@ static void writepages_finish(struct ceph_osd_request *req)
>
>         /* clean all pages */
>         for (i = 0; i < req->r_num_ops; i++) {
> -               if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
> +               if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
> +                       pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
> +                               __func__, req->r_ops[i].op, req, i, req->r_tid);
>                         break;
> +               }
>
>                 osd_data = osd_req_op_extent_osd_data(req, i);
>                 BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);
> --
> 2.36.0.rc1
>

Hi Xiubo,

Since in this revision the loop isn't actually continued, the only
substantive change left seems to be the addition of pr_warn before the
break.  I went ahead and folded this patch into "ceph: check folio
PG_private bit instead of folio->private" (which is now queued up for
5.18-rc).

Thanks,

                Ilya
