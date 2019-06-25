Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C310355752
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 20:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfFYSmZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 14:42:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43334 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfFYSmZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 14:42:25 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so726291ios.10
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 11:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kVkhtjR4A0w3+CCssyiowFiMDjuYjx3VUxizuW+5bhg=;
        b=G8Zus8cx6UHVdhip6q9M3JRsd86qBuz/ipivVXEk6V8Itwk3gUwb9BpfcOQOS8Qu+7
         ZD4+wy+mni5K12zYhnJ1ffMcnlJM+4QDrx7PHtAhSA7qxJgX9UObdcIvI1p4r61BHUOL
         0idZkoExPlm/DsK73UHLsygpr7IbG7O9hQLaW+Af82XC/QDxWavr1b8aZGe6a1sN9Rmy
         AV2OqosYwNKphFoULAo3UG5+xlKcnS67LGpB2VMeyw/u4MYCu+6fEcSrPw6mzf46YDBB
         3l3R023GnPzFYj/f0VmZyntpEEB1C8Z9fAOom+6OrtYq3af4Zd4Y/zYQtekyLk9ZoGiq
         sqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kVkhtjR4A0w3+CCssyiowFiMDjuYjx3VUxizuW+5bhg=;
        b=niPP0PnJyMWJvurDSI8zzJM7pZ/CPdjdh5/GexAz70wvlPOYZs4vb8fUy0ca0ZeM9Q
         vyvrL7spDS7BoUoFFYHIJ7U3BVXzzZWV4Cb23RiUxzQNQwcArHE+FSRJzxfxpP8143IE
         XvVX6pt1uX2TtmohSc4IGSGn3KcehPVISW9vQbPeRuVYMxT2hPIqlMCmM8EnvVJ83DIn
         ZxMNtNGwi4M8UyzKugARVslnsmnqQNmFF7JVcrafWelOzjXNCC5A8WzZiefQx3JSBRs9
         oH1gCjsvq9JAQ/cFPrP897a4U8Skd9R/zn64tNm6OaxDcKcFp/HZOYKCEPFXN7u5sSFF
         jKlw==
X-Gm-Message-State: APjAAAUfT7HxshGfGv231ayg8+OethNVqifbM4zncTchv5n/UTm2q392
        jJhK4Lbw5lBqlxCERxQTXchVEucz7pyxi8tNFts=
X-Google-Smtp-Source: APXvYqx7wnjJKleh2tLoVf2TvaH2P5Is5i8EK5kWTDk2bRer4LwgptV6beVMPwI9oW6hXShWWBUoS5ZxQajIX1A7AZM=
X-Received: by 2002:a5d:924e:: with SMTP id e14mr14244iol.215.1561488144840;
 Tue, 25 Jun 2019 11:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190602022546.16195-1-zyan@redhat.com> <20190602024316.GT17978@ZenIV.linux.org.uk>
 <c609c244-723f-7801-9de7-b2343e24c7ed@redhat.com>
In-Reply-To: <c609c244-723f-7801-9de7-b2343e24c7ed@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 25 Jun 2019 20:42:39 +0200
Message-ID: <CAOi1vP_+c_qyX_BX+rsgG=-Azr9jE6GrNPxq1fExAJ5KgrnZWw@mail.gmail.com>
Subject: Re: [PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Jun 2, 2019 at 9:21 AM Yan, Zheng <zyan@redhat.com> wrote:
>
> On 6/2/19 10:43 AM, Al Viro wrote:
> > On Sun, Jun 02, 2019 at 10:25:46AM +0800, Yan, Zheng wrote:
> >> remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
> >> freezing inode to remove its caps. But VFS wakes freeing inode waiters
> >> before calling destroy_inode().
> >
> > *blink*
> >
> > Which tree is that against?
> >
> >> -static void ceph_i_callback(struct rcu_head *head)
> >> -{
> >> -    struct inode *inode = container_of(head, struct inode, i_rcu);
> >> -    struct ceph_inode_info *ci = ceph_inode(inode);
> >> -
> >> -    kfree(ci->i_symlink);
> >> -    kmem_cache_free(ceph_inode_cachep, ci);
> >> -}
> >
> > ... is gone from mainline, and AFAICS not reintroduced in ceph tree.
> > What am I missing here?
> >
>
> Sorry, I should send it ceph-devel list

Hi Zheng,

I have rebased testing on top of 5.2-rc6 and dropped this patch.
It conflicts with Al's cfa6d41263ca ("ceph: use ->free_inode()") in
mainline and I don't see a new version.

Please take a look.

Thanks,

                Ilya
