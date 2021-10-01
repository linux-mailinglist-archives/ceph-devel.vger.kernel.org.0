Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1999241F63B
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 22:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354645AbhJAUVD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 16:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231689AbhJAUVC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 16:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633119557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=17lw86232ODukMyqGYUAZ0mWagBI2Tr33yRcEf7n6ng=;
        b=D1G6CjefBmrMh14+VZfmy1Q/UnKJiefAUtelUq/YSk3NNfHUQ5Y48czN7ljnN1GBz41N86
        cEbUz8en716d3VHK+jRNcKqqUvAwy723Szm74eUkopELZMF1VAXqrQbCX4YyB7jwTq/xaF
        cAg/oPhNYrkr/jeWwspmQH6QKgBm7hI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-_MFJgqduMsaoXE7SZ7-tBg-1; Fri, 01 Oct 2021 16:19:14 -0400
X-MC-Unique: _MFJgqduMsaoXE7SZ7-tBg-1
Received: by mail-io1-f71.google.com with SMTP id p71-20020a6b8d4a000000b005d323186f7cso9757767iod.17
        for <ceph-devel@vger.kernel.org>; Fri, 01 Oct 2021 13:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=17lw86232ODukMyqGYUAZ0mWagBI2Tr33yRcEf7n6ng=;
        b=wYKJo8iZjk0DR0e98uEI6Own41lQPNcsNnWcLPe2aFSR+4uoXHumbPqun46zDUC2Mx
         gee2YyWUvGwfU4dzPvCy+8Ln4BsCLgT0/PmwkAEh7TFNp2rzvWIaGGcdKp9aIyeCNsyl
         miywpcSf3DDHP7zAk1o/txZBSsNmwxvosNe+xJhfngqK3Y+59QklB/9+moCTmq7qjOoB
         k6EWCmmMfsYEV0b5b2L5sNJImpYYUZAGf1P2arH4Lx+zylgcbff6QIq33vEOcG4DkE1j
         TojH3BAxrogrd2IogAgaijMz5dp/2i0XoNeCyGHlm30uduCsQ9v0+Od82L3jxdNFkRgQ
         y/5Q==
X-Gm-Message-State: AOAM530oyvU2/8HR70827DcLgmf8WP8cyOXECESZXg1A5mKkKY9Ls7We
        rcQBwu0ouRavn+Ycz5ZhLcVunfPgG/6KZHj8yAtcdNe2lNrQFyCUKehtWgyIuWFCXBQkPp5cM/T
        2V0JbLVZUYCThm1ezzT+mXKkbpu10S6RNd/VjNA==
X-Received: by 2002:a6b:f301:: with SMTP id m1mr9449931ioh.3.1633119553584;
        Fri, 01 Oct 2021 13:19:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzLozlkL/bQxTMGZHI7yKVT8mFqf/7X5QCsNHDNy7Z5pgOr2aUvtfRLUQhq1Lcd1V8IfkpTbTIT4yresrwmrU=
X-Received: by 2002:a6b:f301:: with SMTP id m1mr9449913ioh.3.1633119553374;
 Fri, 01 Oct 2021 13:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20211001050037.497199-1-vshankar@redhat.com> <e0f529e2e17cb886bd6a906541fb978be45e0e4e.camel@redhat.com>
In-Reply-To: <e0f529e2e17cb886bd6a906541fb978be45e0e4e.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 1 Oct 2021 16:18:47 -0400
Message-ID: <CA+2bHPYGr4rpJhHb_aX3j-7iYa-tQMfjOmNL6T7R_+26HrUY3A@mail.gmail.com>
Subject: Re: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount
 syntax support
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 1, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote:
> Note that there is a non-zero chance that this will break teuthology in
> some wa. In particular, looking at qa/tasks/cephfs/kernel_mount.py, it
> does this in _get_global_id:
>
>             pyscript = dedent("""
>                 import glob
>                 import os
>                 import json
>
>                 def get_id_to_dir():
>                     result = {}
>                     for dir in glob.glob("/sys/kernel/debug/ceph/*"):
>                         mds_sessions_lines = open(os.path.join(dir, "mds_sessions")).readlines()
>                         global_id = mds_sessions_lines[0].split()[1].strip('"')
>                         client_id = mds_sessions_lines[1].split()[1].strip('"')
>                         result[client_id] = global_id
>                     return result
>                 print(json.dumps(get_id_to_dir()))
>             """)
>
>
> What happens when this hits the "meta" directory? Is that a problem?
>
> We may need to fix up some places like this. Maybe the open there needs
> some error handling? Or we could just skip directories called "meta".

Yes, this will likely break all the kernel tests. It must be fixed
before this can be merged into testing.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

