Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638DB1D8E5D
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 05:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgESDqJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 May 2020 23:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgESDqJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 May 2020 23:46:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2435BC061A0C;
        Mon, 18 May 2020 20:46:08 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w25so12995444iol.12;
        Mon, 18 May 2020 20:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pB5eYPJLJBR6N2fYd++wU5TdLcEDIrnF2XNr7sUNkTw=;
        b=E8OwWyyLIOTmpsl8LvrhTMM35ZAfx2jxsGmzgH3vS6DnMgSpGxdqA4BcEQks4L/5OP
         DBHIReuMpmskeIBqhIVauf+Wmd/wf15dSehtd1UjTKR9iNWf+NZd8H6JCFmjyQ1vCUlx
         WgZf777cViDmhyyf4BqKtGmNR/+LEkPo8WW2Zq5UvifY07od49jvGdsZ7O267PiYT6JC
         H9Ld6as8rxzwJyT2mmnYAYQyhYXWbLT7z41CC+WVhrc1IIp1ryJhjCzYFpEdGN20vUTx
         RZDE0Ku2WI9/V3mYTkRjF/JWIGQMaoOp/TZr0S0vT5zVmnkpHSSuL2Cf/IsEQnkgIbcu
         6VLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pB5eYPJLJBR6N2fYd++wU5TdLcEDIrnF2XNr7sUNkTw=;
        b=bNyZXMYDbcLT+Bzhx8tBN1oVWnw3MpojxpvG9UFdA6gV9lFNMMi0cF6StgcnSrudEA
         3vkZ4mHMLMzX5WVKX5/nJARkCmGHNcNEbcjjLkkt7jGMxqD87brB2/mwiZouTp7MiUez
         Vb3c/zeR15cDy4nJmfTBWEozA1yNtCwSVgTMi397/UL6GqpDWe3IOU5NPRvYgwcZlETi
         iRWVEqutrqrQRojaLMb3kLBvcTfzPvcxtdoJHTV1IUjej+1Sm5KcRYn9KHzD+7syMsoS
         /erTlTI8n6akuwNNX5XPiz9hqTQeIUM6e4zj9WbXdtvLy6mpHeXDe1VxV9FzasvsWP8T
         9orw==
X-Gm-Message-State: AOAM533CHSExuDYnzpHiOvi4o9i/QDN8jC+TciUkGk+HUyPZ8F1UVVfF
        MzHDAnxJdOMkAqKgSfslvrN7RLP4pFWgnFPu/us=
X-Google-Smtp-Source: ABdhPJxas7maaiheBB/b0/RpDkbUbU+YF+zwxERv/9GuLZdORQ1gy/D5mKzIDx+0o32dT7F053hf8bzNpdiB9iXFxas=
X-Received: by 2002:a02:b149:: with SMTP id s9mr17261179jah.81.1589859967396;
 Mon, 18 May 2020 20:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200518174726.GA84496@suse.com>
In-Reply-To: <20200518174726.GA84496@suse.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 19 May 2020 06:45:56 +0300
Message-ID: <CAOQ4uxi21N0O17Z_-Hf-BynKbs7xpOea0JrMF_rvZJ=bUi59_Q@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: don't return -ESTALE if there's still an open file
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 18, 2020 at 8:47 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> a file handle to dentry"), this fixes another corner case with
> name_to_handle_at/open_by_handle_at.  The issue has been detected by
> xfstest generic/467, when doing:
>
>  - name_to_handle_at("/cephfs/myfile")
>  - open("/cephfs/myfile")
>  - unlink("/cephfs/myfile")
>  - sync; sync;
>  - drop caches
>  - open_by_handle_at()
>
> The call to open_by_handle_at should not fail because the file hasn't been
> deleted yet (only unlinked) and we do have a valid handle to it.  -ESTALE
> shall be returned only if i_nlink is 0 *and* i_count is 1.
>
> This patch also makes sure we have LINK caps before checking i_nlink.
>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
> Hi!
>
> (and sorry for the delay in my reply!)
>
> So, from the discussion thread and some IRC chat with Jeff, I'm sending
> v2.  What changed?  Everything! :-)
>
> - Use i_count instead of __ceph_is_file_opened to check for open files
> - Add call to ceph_do_getattr to make sure we have LINK caps before
>   accessing i_nlink
>
> Cheers,
> --
> Luis

Acked-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
