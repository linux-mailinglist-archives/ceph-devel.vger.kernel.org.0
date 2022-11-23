Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D219636DA3
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Nov 2022 23:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKWWxw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Nov 2022 17:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKWWxR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Nov 2022 17:53:17 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8709AC72CD
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 14:53:16 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id e15so13134176qvo.4
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 14:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kZnCvaEQ344vGtn47RMsQAQkT919w64rZm3gu+vPQMY=;
        b=ZO8KT8PP+ynCgfpAsn0gLSY6SzCQhijyPIHusMskwtf9T1rrauFK8Ru8L7xDqiT98Q
         whp7Qv/cl82o4vi2+YEdK/JvvoG6oPw59CunYWdS4vec2yu+4W+UTQwMrh5IPxj3UHlB
         r/ebpwM/LCmalYllI981sk89ihQ71VnQhIaAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZnCvaEQ344vGtn47RMsQAQkT919w64rZm3gu+vPQMY=;
        b=dHdsOeraSHi2JiWHY9WYy6gwEcquQ8XqUviWT0RFpQ30KtB2Si5kPMcR4Nv2rWPj6C
         WejlaZsMm2FojGaT4aZt04VGJce6UXI/wMdw9GmWDkEUbLFtiJOxSBjFBYJf1kXBOq2A
         qzmPFBTCzEP/RYWr/Gobt+0r5J2U/Ja5/BY32F1AeM9EgOwWTcCeBkoAffRB3OGu29DY
         nLkaYpyerrALgy1iSCYahtKfxuGhLn9wL5K97tL4MYkAKWcIkWmYasTaOR24kAkfHo7F
         5X+odfQo2a+IhKXrPq6N4oq3w8BWmkwi3VL4/53w7HjNmssh8QTVHIWlsey5P3mekIg4
         BbRw==
X-Gm-Message-State: ANoB5pmDDpUPoXEWPitfkt+qxSxHt6BDOaZQZyrKI2ffothrNN3oOcTM
        2tofpqHPFV39FXuQhGvnbMjhctziBsEh5g==
X-Google-Smtp-Source: AA0mqf4LxZ4FoebFcX3prjdKkWryscABto+OAD56E/t8Nl6Gb5AY2PhxXtQAUdPL0NJL44eGE44YaA==
X-Received: by 2002:a05:6214:3689:b0:4bb:62b5:bddc with SMTP id nl9-20020a056214368900b004bb62b5bddcmr10342458qvb.91.1669243995305;
        Wed, 23 Nov 2022 14:53:15 -0800 (PST)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com. [209.85.160.172])
        by smtp.gmail.com with ESMTPSA id h17-20020a05620a245100b006cfc1d827cbsm13248283qkn.9.2022.11.23.14.53.14
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 14:53:14 -0800 (PST)
Received: by mail-qt1-f172.google.com with SMTP id fz10so161673qtb.3
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 14:53:14 -0800 (PST)
X-Received: by 2002:ac8:44b9:0:b0:3a5:81ec:c4bf with SMTP id
 a25-20020ac844b9000000b003a581ecc4bfmr16610980qto.180.1669243994092; Wed, 23
 Nov 2022 14:53:14 -0800 (PST)
MIME-Version: 1.0
References: <166924370539.1772793.13730698360771821317.stgit@warthog.procyon.org.uk>
In-Reply-To: <166924370539.1772793.13730698360771821317.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 14:52:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjq7gRdVUrwpQvEN1+um+hTkW8dZZATtfFS-fp9nNssRw@mail.gmail.com>
Message-ID: <CAHk-=wjq7gRdVUrwpQvEN1+um+hTkW8dZZATtfFS-fp9nNssRw@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] mm, netfs, fscache: Stop read optimisation when
 folio removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        linux-mm@kvack.org, Rohith Surabattula <rohiths.msft@gmail.com>,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Matthew Wilcox <willy@infradead.org>,
        Steve French <sfrench@samba.org>,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org
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

On Wed, Nov 23, 2022 at 2:48 PM David Howells <dhowells@redhat.com> wrote:
>
>   I've also got rid of the bit clearances
> from the network filesystem evict_inode functions as they doesn't seem to
> be necessary.

Well, the patches look superficially cleaner to me, at least. That
"doesn't seem to be necessary" makes me a bit worried, and I'd have
liked to see a more clear-cut "clearing it isn't necessary because X",
but I _assume_ it's not necessary simply because the 'struct
address_space" is released and never re-used.

But making the lifetime of that bit explicit might just be a good idea.

             Linus
