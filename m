Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E072710F468
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 02:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLCBNj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 20:13:39 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34116 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfLCBNj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Dec 2019 20:13:39 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so1786274ljc.1
        for <ceph-devel@vger.kernel.org>; Mon, 02 Dec 2019 17:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f16wPMX3Hv5+5LpFCWWiK7eqWkk4a1TMh+b2JYuh2L4=;
        b=KquqAkqUVTyG83FELzXx6nZWqrQom0qPebBeM3l4nUnY0IjRxfw5jl9f4rhB4P0Ys1
         yMMjUqHh9Atftq9/aMH7vPLqvTYv5hjkMQeepjJof4arWmddxk+x0kYqi0oEsm1gm01r
         c0+/cFEMdOFDQe0735Al7ThhTziCMU1XmN/7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f16wPMX3Hv5+5LpFCWWiK7eqWkk4a1TMh+b2JYuh2L4=;
        b=L/cxsW+T8GLN8fo3FiqtLacK48qEafVpt0wxtsavZxYwTZ1JtFw7phEwxGzhKALUwC
         lVEQbgPem0oOIlKskpKqF6nUUkxWSNs485FiS3zbC9+Pk4o366UbQyzjLANjk9MFlBpK
         G7l/0i4RhSN5jhFdkqZDnDGbobta0/i+Y95F13EtEsU2X9exILpTt4tazqMo2KoF6/+q
         S08Kdn44RC1GQD1CUwvUID3eoahZvr0JmKexlIZE9vXJyS30hYHtPTFIebiMwLTRzWy3
         B/oy4fBs0CqLciV4zb8yRvxVJ9g6Yu2Eb/nsXyoZrnpaTh34/Pq73XXK2+BaIR4cbJD9
         4xqA==
X-Gm-Message-State: APjAAAWSWQ53sKvmMEWelwghVKoS9JlODo6tuXR3rOmu+3K7QHKwb/aH
        lTXzfYG7pCmuLM2rT6o8AzVycWTcyOA=
X-Google-Smtp-Source: APXvYqz7QsdYGwl208uPxo4EI8EMo+GROAdBLWF6fJ5L3jl/pGLJsuAz5vaHvYx6Sl0RLP65Rfv4ag==
X-Received: by 2002:a05:651c:1064:: with SMTP id y4mr933484ljm.168.1575335617271;
        Mon, 02 Dec 2019 17:13:37 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id n30sm424411lfi.54.2019.12.02.17.13.36
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 17:13:37 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id k8so1754012ljh.5
        for <ceph-devel@vger.kernel.org>; Mon, 02 Dec 2019 17:13:36 -0800 (PST)
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr889870ljj.97.1575335193641;
 Mon, 02 Dec 2019 17:06:33 -0800 (PST)
MIME-Version: 1.0
References: <20191129142045.7215-1-agruenba@redhat.com>
In-Reply-To: <20191129142045.7215-1-agruenba@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 2 Dec 2019 17:06:17 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj5caXKoukPyM7Zc6A0Q+E-pBGHSV64iZe8t98OerXR_w@mail.gmail.com>
Message-ID: <CAHk-=wj5caXKoukPyM7Zc6A0Q+E-pBGHSV64iZe8t98OerXR_w@mail.gmail.com>
Subject: Re: [PATCH v2] fs: Fix page_mkwrite off-by-one errors
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        ceph-devel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 29, 2019 at 6:21 AM Andreas Gruenbacher <agruenba@redhat.com> wrote:
>
> +/**
> + * page_mkwrite_check_truncate - check if page was truncated
> + * @page: the page to check
> + * @inode: the inode to check the page against
> + *
> + * Returns the number of bytes in the page up to EOF,
> + * or -EFAULT if the page was truncated.
> + */
> +static inline int page_mkwrite_check_truncate(struct page *page,
> +                                             struct inode *inode)
> +{
> +       loff_t size = i_size_read(inode);
> +       pgoff_t end_index = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;

This special end_index calculation seems to be redundant.

You later want "size >> PAGE_SHIFT" for another test, and that's
actually the important part.

The "+ PAGE_SIZE - 1" case is purely to handle the "AT the page
boundary is special" case, but since you have to calculate
"offset_in_page(size)" anyway, that's entirely redundant - the answer
is part of that.

So I think it would be better to write the logic as

        loff_t size = i_size_read(inode);
        pgoff_t index = size >> PAGE_SHIFT;
        int offset = offset_in_page(size);

        if (page->mapping != inode->i_mapping)
                return -EFAULT;

        /* Page is wholly past the EOF page */
        if (page->index > index)
                return -EFAULT;
        /* page is wholly inside EOF */
        if (page->index < index)
                return PAGE_SIZE;
        /* bytes in a page? If 0, it's past EOF */
        return offset ? offset : -PAGE_SIZE;

instead. That avoids the unnecessary "round up" part, and simply uses
the same EOF index for everything.

              Linus
