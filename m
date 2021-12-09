Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4746F694
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 23:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhLIWSE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 17:18:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhLIWSE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 17:18:04 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE18C061746
        for <ceph-devel@vger.kernel.org>; Thu,  9 Dec 2021 14:14:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r25so23666044edq.7
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 14:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RHArNxFMHgs9P3JmMQUjRcZVsX1YeVD3wW/DAeZt5nA=;
        b=JhUfOUJjxhGRzHwksR/Q8zG3IINBIKaphSkRwJzWYADLahSsN6d7219QvbpoEd8Y7k
         Ufk/H24zbV7UnfRzWnZtmEkNZrNUh/75SD5YVhHcTNkE8nvjcjbuV/8uU1FIxASJeztH
         4gA4ykWichWHKmWefAIY/la0fzYo0je1n6xY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RHArNxFMHgs9P3JmMQUjRcZVsX1YeVD3wW/DAeZt5nA=;
        b=F0v7aFWUe4ZOz1/mEhJXyDZ3MTy50k1/OZZ+09e2vH0WKapnmk9F/Sav+cA7+tX5Xd
         ndaDvA791twwKLkzLMA2HAjJdXH9+nt25frloHcoOCUP5vCKnj1EsSrke9bXY31D3Omf
         1fVGJN5kgUE3bvK+ZsUlEqbMYvZjjw/ls6dqurnYirnlIwH5LHfhemJZVu7IBvbiGbfK
         wMELD37cZz2+d+iA80X8dpvp0HAIXC1JOh0hpr3BdF6G09lTrytMeidSvS7EKsMc1gvh
         ycd/uBNzEX7Eac2PzhjKK41uLqqqsGZBQPbDBqw801IznxocFtjWhStog3Iodi/gpIZU
         hhKA==
X-Gm-Message-State: AOAM531MMVGstOq5hM8crEc0mHszU5JKPqG0bvQAxi3qZnONIYaapDvN
        n6m7q3d8RPXX4SiqrON6quJG05WLMMb4dob/RVw=
X-Google-Smtp-Source: ABdhPJzlos2Vzzq6G0hic9V93Yyk0nlrhZhIXSVpWgP/zjO69mIQVbNrF2ENHRHjEyGeNgZ4sSHfIA==
X-Received: by 2002:a17:906:d9c8:: with SMTP id qk8mr19391428ejb.306.1639088068773;
        Thu, 09 Dec 2021 14:14:28 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id he17sm491315ejc.110.2021.12.09.14.14.28
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 14:14:28 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id q3so12112773wru.5
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 14:14:28 -0800 (PST)
X-Received: by 2002:adf:f8c3:: with SMTP id f3mr9535285wrq.495.1639087669394;
 Thu, 09 Dec 2021 14:07:49 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
 <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com> <159180.1639087053@warthog.procyon.org.uk>
In-Reply-To: <159180.1639087053@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 14:07:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com>
Message-ID: <CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com>
Subject: Re: [PATCH v2 07/67] fscache: Implement a hash function
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 9, 2021 at 1:57 PM David Howells <dhowells@redhat.com> wrote:
>
> What I'm trying to get at is that the hash needs to be consistent, no matter
> the endianness of the cpu, for any particular input blob.

Yeah, if that's the case, then you should probably make that "unsigned
int *data" argument probably just be "void *" and then:

>                 a = *data++;   <<<<<<<
>                 HASH_MIX(x, y, a);
>         }
>         return fold_hash(x, y);
> }
>
> The marked line should probably use something like le/be32_to_cpu().

Yes, it should be using a '__le32 *' inside that function and you
should use l32_to_cpu(). Obviously, BE would work too, but cause
unnecessary work on common hardware.

But as mentioned for the other patches, you should then also be a lot
more careful about always using the end result as an 'unsigned int'
(or maybe 'u32') too, and when comparing hashes for binary search or
other, you should always do th4e compare in some stable format.

Because doing

        return (long)hash_a - (long)hash_b;

and looking at the sign doesn't actually result in a stable ordering
on 32-bit architectures. You don't get a transitive ordering (ie a < b
and b < c doesn't imply a < c).

And presumably if the hashes are meaningful across machines, then hash
comparisons should also be meaningful across machines.

So when comparing hashes, you need to compare them either in a truly
bigger signed type (and make sure that doesn't get truncated) - kind
of like how a lot of 'memcmp()' functions do 'unsigned char'
subtractions in an 'int' - or you need to compare them _as_ 'unsigned
int'.

Otherwise the comparisons will be all kinds of messed up.

          Linus
