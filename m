Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420A61997CE
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Mar 2020 15:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgCaNsf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Mar 2020 09:48:35 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38669 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730442AbgCaNsf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 Mar 2020 09:48:35 -0400
Received: by mail-qt1-f195.google.com with SMTP id z12so18315342qtq.5
        for <ceph-devel@vger.kernel.org>; Tue, 31 Mar 2020 06:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9gu2YbyzuEih2wpsMD7IWwODO+azwr8ISq3lRW6B0cc=;
        b=RwNifiKWxnpYKgwxiy/JZZSjDu/VcIq7Txf9FaJ+eRri8nvCVOT7paRNFa88zvF5om
         U14m9c9NY/5yD4t+IcNCldhKfVlhL6stLLmDKJ0zsCfkMCMC4FcBSULTY7wGGZ3nk0pR
         YSfVjV+NEQghycLddyT2VtuSbmijrMjhb7NfU3NzmHDe7pcHzmDjcTdDf0TUvNpnyA3Y
         ldc/gEFOIXsysUycUf5FZxqf7nfH+DC7Ecu6r56zXjjupuf6cU/wMmfmgoPYjo24rwHA
         fRURyw6sHhSlEmFLb0RzXW7PtpCpwjmUyUCso/6tGwiUY+g3keDqUoCnHinpPJeYoIMM
         TMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9gu2YbyzuEih2wpsMD7IWwODO+azwr8ISq3lRW6B0cc=;
        b=i/vSWypoyMxPxjZP/vnJcZ9AzpfawM2+m1qDjFk5Q2zG4iZosLMtrazh7GRexaoVh5
         F4PC+zqbOqHWLlLS7cBrbk3cLEBtL0aS1u7FNRzZabZTTE5/wtCpPmCSUmzHV6mvLLPW
         MG/FAYj6azijWuyzsmTQC0N1Zme2yRGxdqohV2kHeNhNEX3Q0GttaRsLrgrOItJH92Hd
         AzvjyBPWLuvNEaNXgAsoIv7X3ndSIoWX6+O2R5kVQieF8dU8stF/Sw9gSCJxtTFDsw6B
         kj0dKPnrv9+VE/84Tuu50SA8eZ6b5JmIbUV7qtvPiAOR5HVCTKcP8mMX2ZAS9+os/xpK
         YK/A==
X-Gm-Message-State: ANhLgQ1fr0zyhPyKLoQJ8+cEpzRPOMiu0sD241qUuNmPGeYXjl5NTen4
        esVUQMN7iMIvLDuTWsOq+WuGkfAW9E7zrt+amHs=
X-Google-Smtp-Source: ADFU+vtUlGL5NUFS67WJt8gonTqUwGlg7o4BKOGwZPtKKLSvfg07m+mCZWSf+k8uB+DDmDLAX78B2LRrm1DdX1JWRBc=
X-Received: by 2002:ac8:18f3:: with SMTP id o48mr5186026qtk.368.1585662513694;
 Tue, 31 Mar 2020 06:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200331105223.9610-1-jlayton@kernel.org>
In-Reply-To: <20200331105223.9610-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 31 Mar 2020 21:48:22 +0800
Message-ID: <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 31, 2020 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Jan noticed some long stalls when flushing caps using sync() after
> doing small file creates. For instance, running this:
>
>     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
>
> Could take more than 90s in some cases. The sync() will flush out caps,
> but doesn't tell the MDS that it's waiting synchronously on the
> replies.
>
> When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> into that fact and it can then expedite the reply.
>
> URL: https://tracker.ceph.com/issues/44744
> Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 61808793e0c0..6403178f2376 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>
>                 mds = cap->mds;  /* remember mds, so we don't repeat */
>
> -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> -                          retain, flushing, flush_tid, oldest_flush_tid);
> +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> +                          (flags & CHECK_CAPS_FLUSH) ?
> +                           CEPH_CLIENT_CAPS_SYNC : 0,
> +                          cap_used, want, retain, flushing, flush_tid,
> +                          oldest_flush_tid);
>                 spin_unlock(&ci->i_ceph_lock);
>

this is too expensive for syncfs case. mds needs to flush journal for
each dirty inode.  we'd better to track dirty inodes by session, and
only set the flag when flushing the last inode in session dirty list.


>                 __send_cap(mdsc, &arg, ci);
> --
> 2.25.1
>
