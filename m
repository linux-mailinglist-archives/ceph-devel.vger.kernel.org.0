Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8232221851B
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jul 2020 12:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgGHKip (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jul 2020 06:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgGHKip (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jul 2020 06:38:45 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384B9C08C5DC;
        Wed,  8 Jul 2020 03:38:45 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y2so46442192ioy.3;
        Wed, 08 Jul 2020 03:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6qWNT5vkRAAUNzv0WOBodcpzUwaDLty7hLhEuvqFBkc=;
        b=EoqZw5382zK9BTlSQNE7IE941IXXEIXheKUVzhVejDBsW0CLb24j6RFlb//YN3eepJ
         ut+3Ox+0EYt2s4Cjbo4nbwb+pmnNvE7VW1eZG5sz54ysRX35/osZzBC90qrt3CzgR1/V
         WT1FUZby+pRU8vVKIzHxHb+8K8qus+B4hmVHOyZhBVoSP0mAvtUEk9jk6TYYq/hKTo93
         nKwdCrEFkxgtG6HStMKLKZOaWlTCdDU5lrL8mRaOiAepfQlfaWrbQ3JBPEfsxmWnxbaD
         c/9cUw8anxgR6ZcgOIqyzadyyxP2o6nVX3Kdnpf7KuZ8rkDzYK+gHoXatziHp8cSidhV
         xTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6qWNT5vkRAAUNzv0WOBodcpzUwaDLty7hLhEuvqFBkc=;
        b=nXcrsBBUP6BTsEvUrGvpCMl+5Pt/ixDg8SRtVqnxtwPAleza7hJxLFF/Czrm2mqyRu
         tMf4q7m5otCSzpJJ5bGJ1HaPptaaegIE58YCbp8NgEAnT+jQzQrI7SIW2dVAjuo2VzEG
         wgOy0Q0sLZjcZ/I4wnZTRdkVE/d8JrPamf1+dOTNMJ7ng9QQL4dL9aOICIX9GfxtdZGv
         o+zFpF6RSuKUQhwwdUqawyUSiQehjdlGxiWcievsbFsNI1wY6kar+io3fECZW1iNzo7t
         nL0SBZSN4Pt7kGj53izFnAq7WcwHsy0E06K+kwQtdSu3jAEYzuXYhC4Sp1/ZM949GVlC
         5ccg==
X-Gm-Message-State: AOAM532ITNRAju2GZ999rSSWdINlTF6nVyN/aabKKIWaRzW6pp8nFR8h
        Ag6lxBUV1ZwIoQQZMcZ2TdIryWcVOFmol6qo2aM=
X-Google-Smtp-Source: ABdhPJz/oUUfmOWTOBNWon1k8pdhutv1qQxNda1lvQi+wUp9zsIDxgzT4dmhRBhTg7sKsYDOxsN9HugxU14qxHkFZAQ=
X-Received: by 2002:a05:6602:164c:: with SMTP id y12mr36358432iow.143.1594204724534;
 Wed, 08 Jul 2020 03:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200708070322.30695-1-vulab@iscas.ac.cn>
In-Reply-To: <20200708070322.30695-1-vulab@iscas.ac.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 8 Jul 2020 12:38:53 +0200
Message-ID: <CAOi1vP-+raGXYPkumWSbO-YdcMw_hw7VR=K2npPc3NAQC1_J2A@mail.gmail.com>
Subject: Re: [PATCH] fs: ceph: Remove unnecessary cast in kfree()
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 8, 2020 at 9:27 AM Xu Wang <vulab@iscas.ac.cn> wrote:
>
> Remove unnecassary casts in the argument to kfree.
>
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  fs/ceph/xattr.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 71ee34d160c3..3a733ac33d9b 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -497,10 +497,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
>                 kfree(*newxattr);
>                 *newxattr = NULL;
>                 if (xattr->should_free_val)
> -                       kfree((void *)xattr->val);
> +                       kfree(xattr->val);
>
>                 if (update_xattr) {
> -                       kfree((void *)name);
> +                       kfree(name);
>                         name = xattr->name;
>                 }
>                 ci->i_xattrs.names_size -= xattr->name_len;
> @@ -566,9 +566,9 @@ static void __free_xattr(struct ceph_inode_xattr *xattr)
>         BUG_ON(!xattr);
>
>         if (xattr->should_free_name)
> -               kfree((void *)xattr->name);
> +               kfree(xattr->name);
>         if (xattr->should_free_val)
> -               kfree((void *)xattr->val);
> +               kfree(xattr->val);
>
>         kfree(xattr);
>  }
> @@ -582,9 +582,9 @@ static int __remove_xattr(struct ceph_inode_info *ci,
>         rb_erase(&xattr->node, &ci->i_xattrs.index);
>
>         if (xattr->should_free_name)
> -               kfree((void *)xattr->name);
> +               kfree(xattr->name);
>         if (xattr->should_free_val)
> -               kfree((void *)xattr->val);
> +               kfree(xattr->val);
>
>         ci->i_xattrs.names_size -= xattr->name_len;
>         ci->i_xattrs.vals_size -= xattr->val_len;

Applied.

Thanks,

                Ilya
