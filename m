Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C951B04BA
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Apr 2020 10:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgDTIom (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Apr 2020 04:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgDTIom (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 20 Apr 2020 04:44:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3561EC061A0C;
        Mon, 20 Apr 2020 01:44:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z2so5694438iol.11;
        Mon, 20 Apr 2020 01:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNDbSfCazHQDf7phsNR0tff/qq1UYvMg1+Ac+fjXFMk=;
        b=f6CESR/Hb+bWxE9QsDtwL1q6oqFSwd37n8H3rPp27k2lUAO4xl1xaUVj0FV2RhAGWI
         olbuGTOvhRwc9UzmOVwdxDpihcv3gc0PTrnkGWZjXx4SolEltn5ORi6PF8g95vaYHi9r
         SM+xDwkLl76voT0Yz7ETwqpwJqOFTEWuD3FOj4KbtknMLxlic8Wm+LjKc7D67I3MIljA
         HXaAkKXUs9rZBnYwKZBgl8tpxTx8JzDGWiW2QIodP7HHp92UaZ/YyDHSzUJWwWh70CGV
         zuAk26nkOzT8xj2Wrf+dIQxY2tX26GGjkHIKpKO5cPqfnshZnl+VgjglqxifxxV2Ooku
         bM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNDbSfCazHQDf7phsNR0tff/qq1UYvMg1+Ac+fjXFMk=;
        b=KAinp5LApNrgFmjJCB+4TX+vAbajg4YjyYCXdhW+nkvwVMEOfSv8wZY1nya5BkZn9n
         egcz1k9t6uWGaC7nCVGouf1ZfX4f1bzrQpK+Osw7Ej35M68iHt/GZ7z5TZTVVNqwApJ5
         psS1fol2AjqUldmvc+p1dyHfl94DlVZpol2IiUh8W3gpZdvMMdHyK1GHSic5suPvB4fR
         3nksf96RdQbHEJAPH9yRN2Lexo2j6EkW34zAjfg+UGEs6XZW3Asc1WEY4DPGt1HTqE5q
         w0+k8P/kksQEZitZGSBLk+phDik7k5xDRKJaoI7bYqnX4Z7BWUDTZXS1VxbEvThTGXtK
         K3UA==
X-Gm-Message-State: AGi0PuaA9LXT1MGw8qZaOalqdNTkPuOd5g8QYVr8GHB0UTuftdQjne67
        +1rQ6G0Gf8k+uiAUFA47zwgA7o5GfUPD638BgUQ=
X-Google-Smtp-Source: APiQypIUtyo1F+2iDV9EYQWRG4fdmwyQuUiNFNv/WSv+f+iWJ9SaRxJdpdKRSNSTnoyJOe1KkDI9mDMybj2Lq0gb3T4=
X-Received: by 2002:a05:6602:1545:: with SMTP id h5mr14595002iow.32.1587372281669;
 Mon, 20 Apr 2020 01:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <1587361243-83431-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1587361243-83431-1-git-send-email-xiyuyang19@fudan.edu.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 20 Apr 2020 10:44:37 +0200
Message-ID: <CAOi1vP_-82vLSG6UeeLToRGjNepE--fnj8tsb4y8e7eAoH9tCA@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix potential ceph_osd_request refcnt leak
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, yuanxzhang@fudan.edu.cn,
        kjlu@umn.edu, Xin Tan <tanxin.ctf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 20, 2020 at 7:41 AM Xiyu Yang <xiyuyang19@fudan.edu.cn> wrote:
>
> ceph_writepages_start() invokes ceph_osdc_start_request(), which
> increases the refcount of the ceph_osd_request object "req" and then
> submit the request.
>
> When ceph_writepages_start() returns or a new object is assigned to
> "req", the original local reference of "req" becomes invalid, so the
> refcount should be decreased to keep refcount balanced.
>
> The reference counting issue happens in a normal path of
> ceph_writepages_start(). Before NULL assigned to "req", the function
> forgets to decrease its refcnt increased by ceph_osdc_start_request()
> and will cause a refcnt leak.
>
> Fix this issue by calling ceph_osdc_put_request() before the original
> object pointed by "req" becomes invalid.
>
> Fixes: 1d3576fd10f0 ("ceph: address space operations")
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  fs/ceph/addr.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 7ab616601141..b02c050a3418 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1126,6 +1126,7 @@ static int ceph_writepages_start(struct address_space *mapping,
>                 req->r_mtime = inode->i_mtime;
>                 rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
>                 BUG_ON(rc);
> +               ceph_osdc_put_request(req);
>                 req = NULL;
>
>                 wbc->nr_to_write -= i;

Hi Xiyu,

I think this reference is put in writepages_finish().  Putting it in
ceph_writepages_start() will result in freed pointer dereference in
libceph (in __complete_request() or elsewhere).

Thanks,

                Ilya
