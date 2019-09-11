Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CD6B0240
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 18:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfIKQ5Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 12:57:24 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41461 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbfIKQ5Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 12:57:24 -0400
Received: by mail-io1-f67.google.com with SMTP id r26so47338288ioh.8
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 09:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDwcycTAvUrm82WEvgUG6zHH16UXkBb/vqH63385ZL8=;
        b=jbPRYQUWZFRnK+deRGUYr8L4FIGcQfOMD9VErg0yAQPUdaKroZykdGpH1+eFRTMvk9
         HC7KDpOtuSUFXFojY3AoZnkgG2G7yxw7s2WWTs8BcoPsWMHeO6DfGpr99H7D29Wo3V79
         c3MtKbItU5OH5FwaF7mt3dcWEVIV6dBjvGgDlLlB5h6J5/F7DhK3HwE2qtyFz7O8XNoP
         i0hRn3syOUuk5f4xXHp7E7bbxkiDS9NDnHY1hq6jARkdLVkplWQxOuV1TTfmfm2KxR6p
         JhGVGLOKjjJKmPpsK2FML+EQnOe0ffcCTZUM86WIFS96NRz09Y5w1MYq3JchaWeKvLVz
         Za8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDwcycTAvUrm82WEvgUG6zHH16UXkBb/vqH63385ZL8=;
        b=NrFvhVKXReGF7cWXHT9S08IRgbLMaqJxF1PANQet5XRK2kk0Wmo1o5lld1s1wOvH6e
         FFS6zgak00iosOt7u6OC3KLSvDuslmMJIrJHw22KW+xkGQuG8sr9pGbyntsMHzqctRnZ
         e8izKgFXrIXvPsa3L83NX0F7gsXr5Ja5EFWJ0Its1a+6dd0t8blA//x4ilfsfMBVmsMI
         DeC0xxYH7BTczNLt4nsgkEoHc8R+spdTVhAxXJ0OBYgjyLuYOSMhMr2Zk1tH+8FFFkBN
         bi7dAbhZDbhHzW5Av3gBTrlZvY9NKDRfhDTLlRScYsw4r5wEMUOkF/zyMpytH3gpIUZ/
         uZIw==
X-Gm-Message-State: APjAAAWJoLzDlylu3DWr+qEMt5POfoBUdgP2MS6hcFOrZdoKvizfABJp
        rw15Om2frlqWooOkSvJkz32MZKBbz9ksFcP3Mk8=
X-Google-Smtp-Source: APXvYqxREwQq5m6Y87R4hgTNFkcyFo+Ktj7QA3E6FULEKoqPyaCZBXFHWIAxayT/jD2qWq6IsuFAAsZQFsPkFRTzxLQ=
X-Received: by 2002:a02:948c:: with SMTP id x12mr37886849jah.96.1568221041709;
 Wed, 11 Sep 2019 09:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190911163735.23351-1-jlayton@kernel.org>
In-Reply-To: <20190911163735.23351-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 11 Sep 2019 18:57:15 +0200
Message-ID: <CAOi1vP9oXAA8u8mEPU-rPf=Sk1xoPEfj471ucEM28xtSnE4DqQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: clean up error return in ceph_parse_param
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 11, 2019 at 6:37 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Ilya, I'm planning to just squash this into the mount API conversion
> patch, unless you have objections.
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5ccaec686eda..2710f9a4a372 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -298,7 +298,7 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
>                 else if (mode == ceph_recover_session_clean)
>                         fsopt->flags |= CEPH_MOUNT_OPT_CLEANRECOVER;
>                 else
> -                       return -EINVAL;
> +                       goto invalid_value;
>                 break;
>         case Opt_wsize:
>                 if (result.uint_32 < (int)PAGE_SIZE || result.uint_32 > CEPH_MAX_WRITE_SIZE)

No objections, we want the error message.

Thanks,

                Ilya
