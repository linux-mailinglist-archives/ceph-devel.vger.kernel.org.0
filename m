Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890016368BE
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Nov 2022 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbiKWS10 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Nov 2022 13:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239624AbiKWS06 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Nov 2022 13:26:58 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B7B697CA
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 10:26:57 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id l2so11758191qtq.11
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 10:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/jG5QaYqTRKNFcJtqKGHj4SfbKFSJH0wslCbBk+0rc=;
        b=WtEZfFy9CjWS25vRvH8BUGmfQ5TppWVPJY29aYmVjK2t/Gqd80v173byCSBDvOcqZ5
         GS3iagkeA7ssVh/ddKEkJKHeWkCPYto/COdNwh44sfuBXjAau3yrVZ6HAJiXAaELgCMQ
         DakZoiuRSNhC/sDbjfyndFBio5BbqUEFc1b48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/jG5QaYqTRKNFcJtqKGHj4SfbKFSJH0wslCbBk+0rc=;
        b=rk6DspCkJqwslCODnCsypw5V9FFt2fkA8ah6iyNRLidca1Bjakq+njK5zZO2ceCIvd
         U9i81XVvhwGH8lP2wfpROfcUD8DAjq4Le0xlHkTkjaG5zA/6SyOFwuUazOufwk71+8HT
         l3IwqbmdrT1mIXcwWBN13OwWE3vnGS1E02h2USRaPIFnfWs9FRZ67oegzF1zvxqA8/Lx
         rTQDMtyEWw7K/1R1NAl6myQCb219iHAXD/ss4ZCcRwIxnnvuCs2sDZSeAeXTjiwMB4F3
         MQUYpGJYxFJUVKPR0z8iUgJdzmNmfAHeWBu96c9ZqWFHW5SRpCmWgE9qYXUgfj0bh+jq
         Qjtw==
X-Gm-Message-State: ANoB5plIGmgYQlMx7HcXZoJaWjn+gDbJJqGELsDCWqdOUXUJj+m+eA0d
        2XNKkcw4Y1+SoAC+vSlwxvnIShRT/vBLuw==
X-Google-Smtp-Source: AA0mqf5VkGhNeYjPxklY28+/mZLHnSNJO9kOmQ5vpf+x/gzEgmr1u22pN5VeDEiAklPVGU7Lp2k1Xg==
X-Received: by 2002:ac8:505a:0:b0:3a5:285c:d9fb with SMTP id h26-20020ac8505a000000b003a5285cd9fbmr28243908qtm.408.1669228016439;
        Wed, 23 Nov 2022 10:26:56 -0800 (PST)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id j3-20020a05620a288300b006fc2cee4486sm1432954qkp.62.2022.11.23.10.26.52
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 10:26:54 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id cg5so11756042qtb.12
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 10:26:52 -0800 (PST)
X-Received: by 2002:ac8:41cd:0:b0:3a5:1ba7:717d with SMTP id
 o13-20020ac841cd000000b003a51ba7717dmr9188380qtm.678.1669228012067; Wed, 23
 Nov 2022 10:26:52 -0800 (PST)
MIME-Version: 1.0
References: <1459152.1669208550@warthog.procyon.org.uk>
In-Reply-To: <1459152.1669208550@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 10:26:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
Message-ID: <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
Subject: Re: [PATCH v3] mm, netfs, fscache: Stop read optimisation when folio
 removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, dwysocha@redhat.com,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 23, 2022 at 5:02 AM David Howells <dhowells@redhat.com> wrote:
>
> Is the attached patch too heavy to be applied this late in the merge cycle?
> Or would you prefer it to wait for the merge window?

This patch is much too much for this point in the release.

But I also think it's strange in another way, with that odd placement of

        mapping_clear_release_always(inode->i_mapping);

at inode eviction time. That just feels very random.

Similarly, that change to shrink_folio_list() looks strange, with the
nasty folio_needs_release() helper. It seems entirely pointless, with
the use then being

                if (folio_needs_release(folio)) {
                        if (!filemap_release_folio(folio, sc->gfp_mask))
                                goto activate_locked;

when everybody else is just using filemap_release_folio() and checking
its return value. I like how you changed other cases of

        if (folio_has_private(folio) && !filemap_release_folio(folio, 0))
                return 0;

to just use "!filemap_release_folio()" directly, and that felt like a
cleanup, but the shrink_folio_list() changes look like a step
backwards.

And the change to mm/filemap.c is completely unacceptable in all
forms, and this added test

+       if ((!mapping || !mapping_release_always(mapping)) &&
+           !folio_test_private(folio) &&
+           !folio_test_private_2(folio))
+               return true;

will not be accepted even during the merge window. That code makes no
sense what-so-ever, and is in no way acceptable.

That code makes no sense what-so-ever. Why isn't it using
"folio_has_private()"? Why is it using it's own illegible version of
that that doesn't match any other case? Why is this done as an
open-coded - and *badly* so - version of !folio_needs_release() that
you for some reason made private to mm/vmscan.c?

So no, this patch is too ugly to apply as-is *ever*, much less during
the late rc series.

                 Linus
