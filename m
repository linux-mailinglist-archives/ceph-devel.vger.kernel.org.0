Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9673A2BD5
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Jun 2021 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhFJMpb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Jun 2021 08:45:31 -0400
Received: from mail-ua1-f49.google.com ([209.85.222.49]:42629 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJMpa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Jun 2021 08:45:30 -0400
Received: by mail-ua1-f49.google.com with SMTP id w5so1215332uaq.9
        for <ceph-devel@vger.kernel.org>; Thu, 10 Jun 2021 05:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERGvPKyejnfegUXiUI5TBALLR98HuWU+7/Q+tACPbYI=;
        b=bWmonaOQtQnoMrqggNjQmbBLp/OFsefkhaXRpT3N30oDxasxyxX5+zHqOhyxg8TwQ1
         9WhDWldZuNugQzNq9CRVa79/7odXcgVZfZJpa4jozV3UwwVJh+rViZAq1j+cqvO83+lk
         Ul0lp34cK0STCoHisDcJwkiJqPEl1W1Jca9Ac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERGvPKyejnfegUXiUI5TBALLR98HuWU+7/Q+tACPbYI=;
        b=kmE4HDcEdcU8tHeeXTUDgTLkTjE7rayPD/Sdd4DwgWnpPbLcGDu7OqOZ1zCjYFbOF8
         cFq8Ht8lsPovaVOhneJFqc5pu4ZsBG+491jMeQCfT8uCGLVcsivXJFtaaRNUAy+fQl/V
         fKFJvQtgWIhnb/30C1/Z7aiooUxBUGSu7RBoEiPTvkmmMQANH7LAt/VAtkDHeLSbcLCu
         tDBd358kScC2vhMc5ZjoJWDyEHl98FQJdUZdW/iPJJCjoC1oRkUoFoiufNlC5EvV/b8k
         1EREQxz+GKB79E3f4YHjaqONxklveQDelHeIWRJtMeht3LBR8XLBqt9AzU40p/+cdqxE
         oDPQ==
X-Gm-Message-State: AOAM533g+y2Z9HDUPit2LOn3rMyttcFLR6A7P4c5dXGIULU+QF7tytP6
        vxLzz+ZCQAr7kPoBl3Aurh+7FDO5qzff6kLY+k/SyQ==
X-Google-Smtp-Source: ABdhPJzSnBnKZyOmEQg1Mlk1J3k9vxKYbX0hKrYXjQBdDrHZwFo89gBvp5Cl9ryn+jRW8T0jKkHsp9O4DmV9/7gYf0I=
X-Received: by 2002:ab0:2690:: with SMTP id t16mr4105093uao.9.1623328942641;
 Thu, 10 Jun 2021 05:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210607144631.8717-1-jack@suse.cz> <20210607145236.31852-12-jack@suse.cz>
In-Reply-To: <20210607145236.31852-12-jack@suse.cz>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 10 Jun 2021 14:42:12 +0200
Message-ID: <CAJfpegtLD6SzSOh0phgNcdU_Xp+pzUCQWZ+CB8HjKFV5nS3SCA@mail.gmail.com>
Subject: Re: [PATCH 12/14] fuse: Convert to using invalidate_lock
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, ceph-devel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mm <linux-mm@kvack.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Ted Tso <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 7 Jun 2021 at 16:52, Jan Kara <jack@suse.cz> wrote:
>
> Use invalidate_lock instead of fuse's private i_mmap_sem. The intended
> purpose is exactly the same. By this conversion we fix a long standing
> race between hole punching and read(2) / readahead(2) paths that can
> lead to stale page cache contents.
>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
