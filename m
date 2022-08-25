Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD30D5A0B91
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 10:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiHYIdZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 04:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiHYIdT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 04:33:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4753A6C13
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 01:33:10 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w10so12990515edc.3
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 01:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=IHch6zcddsdL/TwYUz3yznVR/l24wZgDKAFB/BTfRyc=;
        b=CijBPIML3W4nY2Bf5RCNhnJJXxDZlYjiEe54kv1ABe0Vgh/RmOvQj/CQJVzAH8Hqpp
         Zlq0eUteWBP3AneBNLVwUKXq9K3OBiwPmxLBppzTjOB45Iuu0wVtMMa/JdJgUOZC40Ui
         7aFnJyHeCBNKRpV4aSfh6sUYevXKaup+LvUXBZpRAiaG0YL3YwDdLE1EbVroV/VfdzxG
         Iound+rjQGfHjP+dGIcZH6N/UENmaqkAgc6MALvLswlC5fORFqdfqFIto5Mtl7vOzS1r
         BiEyAsSZzQ+gqtCJxdubA/Qx1+XoeFyI9Ro16EVroOA6CnV2BrkKGropVA/zThLfcddQ
         mlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=IHch6zcddsdL/TwYUz3yznVR/l24wZgDKAFB/BTfRyc=;
        b=ngOOKHzCnC8kR9KDBigX5MJJ+2H6U/0vJkYxSWbZ/sie+c7twLBkMGG802avLO+KZI
         zX9gR8IEC94HQfHB86dgQxXOrIftBzlwRTOawkeGx3+KeLZLXfPOYhby1Zwx0UECHI2p
         3os7JwZXA32qFfsWApKS4xvJxQJM8lc/Ssf+0B2qkQSgch+1a/jFmr1KPbiEb/4J/6yM
         yX0hooyvkJ53zgSdO9DBzx2J3FHvh4XCan7xrPUHjokAiTpEsbMu3kJN704xYV0kO8FL
         N6jVDp0UAZx58GDqCn1Oo3twka139qpGnOL1Bi8coqI1mKlYMv9Pl458Vf6VZKhjZ2sn
         fHtQ==
X-Gm-Message-State: ACgBeo1Mx/93rqoOc/bNBhNv2PPKRO1cd7IQpZw0IkMHuBszsRLkZhX/
        O0TucqX59tVIIevdXE3w9d3kC6wx8SadOw8VlxzdnLPY7tTiwQ==
X-Google-Smtp-Source: AA6agR7n9/1/Wrdsk2ecgHlM/rRfI2F7BA5dG5TZmWeDNeAZ/U99HD4bU15+kpsDWDeKAy1mrPyDvlLZR91EYhtWEyk=
X-Received: by 2002:a05:6402:42ca:b0:446:8f11:3b96 with SMTP id
 i10-20020a05640242ca00b004468f113b96mr2284056edc.353.1661416388730; Thu, 25
 Aug 2022 01:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220824205331.473248-1-jlayton@kernel.org>
In-Reply-To: <20220824205331.473248-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 25 Aug 2022 10:32:56 +0200
Message-ID: <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 24, 2022 at 10:53 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> ceph_sync_write has assumed that a zero result in req->r_result means
> success. Testing with a recent cluster however shows the OSD returning
> a non-zero length written here. I'm not sure whether and when this
> changed, but fix the code to accept either result.
>
> Assume a negative result means error, and anything else is a success. If
> we're given a short length, then return a short write.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 86265713a743..c0b2c8968be9 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>                                           req->r_end_latency, len, ret);
>  out:
>                 ceph_osdc_put_request(req);
> -               if (ret != 0) {
> +               if (ret < 0) {
>                         ceph_set_error_write(ci);
>                         break;
>                 }
>
> +               /*
> +                * FIXME: it's unclear whether all OSD versions return the
> +                * length written on a write. For now, assume that a 0 return
> +                * means that everything got written.
> +                */
> +               if (ret && ret < len)
> +                       len = ret;
> +
>                 ceph_clear_error_write(ci);
>                 pos += len;
>                 written += len;
> --
> 2.37.2
>

Hi Jeff,

AFAIK OSDs aren't allowed to return any kind of length on a write
and there is no such thing as a short write.  This definitely needs
deeper investigation.

What is the cluster version you are testing against?

Thanks,

                Ilya
