Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47FD75965E1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Aug 2022 01:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiHPXKG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Aug 2022 19:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiHPXKD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Aug 2022 19:10:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2271B923C3
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 16:10:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r4so15354235edi.8
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 16:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AMn3B3jYdCVxak8yksa8T7jS8rFLGuSxkkP5+8axw1A=;
        b=Vm9rZhcUXu8DUu2U13LfpsCp0dP7Fg/9rAJeZp9YtlQ9Rq7Y9VtHRIc4gUGBrf6ABe
         +ZW0OMEq5BRJFyJbSJSx/y9p2lZo+15ohYnjJN9vM+Oe2v51uKNkPu3wDgexSVnVScq8
         +r2XB8pHGFS6YRv4syJ3wdNKjMUHxv1d12zww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AMn3B3jYdCVxak8yksa8T7jS8rFLGuSxkkP5+8axw1A=;
        b=zvCWexo75zwpAOnQaU6Lh+1wdFG64h714Z/4ZL6lAVjqea5EfR6PWUsGyaKqZXcarA
         U1JLIwOUGaRYWs19t8RksrKFg5xn56jzXE1Zw9Jp3Hzwu1GiPJOYWZkEy+eF58/1R4h4
         SdfRz1xn7ySgmtf7y/xtkCNzEX+D/+7bJXC5IEMhrtyYCSbhfkUo77Ogx3vOaWzo9hzz
         821Rh5+/aSgUBTqqFqPJACx1Qibhz3CssmHljsP4QabnQlIixU1wNSDhgLSeJKABWuel
         7xAbFuq2MA8fphc4GWLYT7Yq1AjfuTQWO+CjKdC1+sMZAtSWBbzvRN3jjHKXWTUhQCIk
         ucaQ==
X-Gm-Message-State: ACgBeo3WLE9ek4DfaSnz19Rl2hSY2jWxKKkWX4Nhe76ZhlJteGHrxTmO
        LmDAbtpagUofUklLWCrG1mDqx/tM0Q9XJ4Lv5kc=
X-Google-Smtp-Source: AA6agR442wXtj/cvKAvapv454EngT24721gVWsVt3TBM1hQoBvO7q2Bq87U4MUYjpGUK/tCIu9sHvw==
X-Received: by 2002:aa7:dc17:0:b0:441:e5fc:7f91 with SMTP id b23-20020aa7dc17000000b00441e5fc7f91mr20536870edu.301.1660691400454;
        Tue, 16 Aug 2022 16:10:00 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id eh12-20020a0564020f8c00b00445b822005dsm899742edb.6.2022.08.16.16.09.58
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 16:09:59 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so138011wmb.4
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 16:09:58 -0700 (PDT)
X-Received: by 2002:a05:600c:2195:b0:3a6:b3c:c100 with SMTP id
 e21-20020a05600c219500b003a60b3cc100mr383338wme.8.1660691398572; Tue, 16 Aug
 2022 16:09:58 -0700 (PDT)
MIME-Version: 1.0
References: <YvvBs+7YUcrzwV1a@ZenIV> <CAHk-=wgkNwDikLfEkqLxCWR=pLi1rbPZ5eyE8FbfmXP2=r3qcw@mail.gmail.com>
 <Yvvr447B+mqbZAoe@casper.infradead.org> <b05cf115-e329-3c4f-dee5-e0d4f61b4cd5@schaufler-ca.com>
In-Reply-To: <b05cf115-e329-3c4f-dee5-e0d4f61b4cd5@schaufler-ca.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Aug 2022 16:09:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiRs8k0pKy36cXYnBFVCJDP5DQMf6JM7FnRJz5tF4cMBA@mail.gmail.com>
Message-ID: <CAHk-=wiRs8k0pKy36cXYnBFVCJDP5DQMf6JM7FnRJz5tF4cMBA@mail.gmail.com>
Subject: Re: Switching to iterate_shared
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        coda@cs.cmu.edu, codalist@coda.cs.cmu.edu,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 16, 2022 at 3:30 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Smack passes all tests and seems perfectly content with the change.
> I can't say that the tests stress this interface.

All the security filesystems really seem to boil down to just calling
that 'proc_pident_readdir()' function with different sets of 'const
struct pid_entry' arrays.

And all that does is to make sure the pidents are filled in by that
proc_fill_cache(), which basically does a filename lookup.

And a filename lookup *already* has to be able to handle being called
in parallel, because that's how filename lookup works:

  [.. miss in dcache ..]
  lookup_slow ->
      inode_lock_shared(dir);
      __lookup_slow -> does the
      inode_unlock_shared(dir);

so as long as the proc_fill_cache() handles the d_in_lookup()
situation correctly (where we serialize on one single _name_ in the
directory), that should all be good.

And proc_fill_cache() does indeed seem to handle it right - and if it
didn't, it would be fundamentally racy with regular lookups - so I
think all those security layer proc_##LSM##_attr_dir_iterate cases can
be moved over to iterate_shared with no code change.

But again, maybe there's something really subtle I'm overlooking. Or
maybe not something subtle at all, and I'm just missing a big honking
issue.

            Linus
