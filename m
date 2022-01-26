Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B18349CF88
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiAZQWM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbiAZQWL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:22:11 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A247C06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:22:11 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id m90so43902656uam.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 08:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6gcvbb4vYWEycfE6r4JgTzckICigKCNzS1ilHXt52c=;
        b=LhOpUiR4cnfEpVoALhVrZldT522IDcVS7XL054L8Zu/q8Yn1jyukbbSOfp9HV0RLw1
         rUwI4L1vubH6x0CHy1MOtRcZYUY3agMY5HzzqWxZ7B6rxPtkg2IIdR0d+hHO5HSGAit1
         PoHcKsB65XHAs4ev1ahlMLCtN0/BVxToMhJXFfmM4HO0HGyzV56S/Oc6dm39sWgDLZqc
         0HzCTF8+WDWBjMBLi6Zpm2qMQdAFJgxKjSv+4RoN/w05SYbIFOk42i5BmEZu0dnuMm/1
         n/hXpYwPRqwbpEZm2KvDG3tGQx2n1eqjPDGeAVVuOKwyFjyHW/ZZQTfsteswZfmzPa5S
         UjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6gcvbb4vYWEycfE6r4JgTzckICigKCNzS1ilHXt52c=;
        b=wirfydMcDpP+4zfGnXa0PUOv3dB55zVVaxh1X7Matapbyx1x+N+7RY/wcDKcF/JCjU
         iVlF7du9ngZeQpUFlsPhrZeslvQWRbtPb3suRoD/7O7U/PIDKdvCw8NEo9X9Jp9Yst2L
         4olZGQcV3PCMCfWxpRzrOLSrANMXjjuCQgtUm4Zk1pZmur+VR21k5qZnRyCb/8lNLTmm
         samiMNo/YSqas1h9LP75H1B8/t5HDk0ANZ6JCaw63g7CkKmA/vrzY9BtdVis3y5ICKyV
         gatF7wkXJWrfiwPUWBdAruQFLMOiewmgtnMb76Xc6PljVofwpPSlgJHl6CGxiZEdJYAb
         TIPQ==
X-Gm-Message-State: AOAM530Q9G4J0l613VluHUADX9ve/xMLeV93rtzIL9A374cp8TTCjSDJ
        6wPZsDYgiWFokgPLUX4dQSPwux2IV699jijvFvhBpYZfc+U=
X-Google-Smtp-Source: ABdhPJyhUcVQWGOr3Edz0llvnhA4PdG4oUhSux3RtFLenAsq+pmblPAvlirL/bZzPhBWv4W1UF6swfFCcwOPg+te/JU=
X-Received: by 2002:a05:6130:3a0:: with SMTP id az32mr11053461uab.140.1643214130330;
 Wed, 26 Jan 2022 08:22:10 -0800 (PST)
MIME-Version: 1.0
References: <20220125210842.114067-1-jlayton@kernel.org>
In-Reply-To: <20220125210842.114067-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 26 Jan 2022 17:22:19 +0100
Message-ID: <CAOi1vP8zhO4omTv2eVb43KbsqL4iqxi9FW55K7cXi8ue-NuUKQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: properly put ceph_string reference after async
 create attempt
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 25, 2022 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The reference acquired by try_prep_async_create is currently leaked.
> Ensure we put it.
>
> Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index ea1e9ac6c465..cbe4d5a5cde5 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -766,8 +766,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>                                 restore_deleg_ino(dir, req->r_deleg_ino);
>                                 ceph_mdsc_put_request(req);
>                                 try_async = false;
> +                               ceph_put_string(rcu_dereference_raw(lo.pool_ns));
>                                 goto retry;
>                         }
> +                       ceph_put_string(rcu_dereference_raw(lo.pool_ns));
>                         goto out_req;
>                 }
>         }
> --
> 2.34.1
>

Hi Jeff,

Where is the try_prep_async_create() reference put in case of success?
It doesn't look like ceph_finish_async_create() actually consumes it.

Thanks,

                Ilya
