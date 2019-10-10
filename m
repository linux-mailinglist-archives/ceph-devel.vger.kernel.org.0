Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B61D1FB1
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Oct 2019 06:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfJJEgQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Oct 2019 00:36:16 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:34553 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfJJEgP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Oct 2019 00:36:15 -0400
Received: by mail-ot1-f48.google.com with SMTP id m19so3744721otp.1
        for <ceph-devel@vger.kernel.org>; Wed, 09 Oct 2019 21:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2aiytYTusZVNvIPxYqXGcb5faB6M/RJribfGqk39JQ=;
        b=B6r9QRwIK/bGY0FjX0OPh0qAO0RnC456GeRXUgo7JVHpNekloxg0Udyad6oXfarCPA
         eI1pEm9fVHQ+LixElEQb34bI9c1I0Dy7UaraQJ6J4Lbz3c5TL14cqbYmWH/58sQGswWs
         rYjJPjwptAl5xUCgoMnGtQU7jSrQY9t/0Tuu/pASdunsWX6XrDClZ7w/WgATA85cK5a+
         aACkBNUoDug42AmFr/nPjqsnZl9BG6TRO8BCaD9TRZkJzGcYUoLn2bXY/kVvmfi/vwhn
         MQJE+DecAVe3En2dwdushNpZF/XZO/zF96hZEvn3rnToel5NrHrhaljZFW2Tj498kRp6
         Wvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2aiytYTusZVNvIPxYqXGcb5faB6M/RJribfGqk39JQ=;
        b=ZBGslajoT9BqcXDs1qgiI0hIc75njhB/0/wc/rQALfJyNaeQgfOlXmDwlJOWZn0X7S
         lcdJImiGVWANmWeM0P4byigZ8ztJSYchMrcFBgSxOMXsnElWIpEfxwXCXdTVfR68SigS
         How6SnPuqnTgSCf7n7puhSLcklQvTiXVvYt0xQ5a3YjI05Bz6aHrgSabnUcOBNV1WfHr
         8HwntKvbe93iaT5erqVoQ5i/buyKNSshvxziLvkiDQ4CrZSLuIVWeII3eKg5/+zVDxp+
         GqxrIMmm7R4m7hg1PY4kteBgUS+9TSOmtgBmI5bI8xm+kTCFz3nTTYobk6h++79W8moF
         nCng==
X-Gm-Message-State: APjAAAVnQZSlYkJ23KAs2mWryweRmOzBkFGEzSPJzg3r7XcQVCf9ZFY8
        gCv43OWx1NHYS/Fz+6rhN83wd6lv1nDFLieXzp4wnA==
X-Google-Smtp-Source: APXvYqwwM8YeH0S0k/7cwhOQ0U7DrMYRZOJ2uL/QTW8mP3lxpH6+/Lj1PHUBrBvw13m4oordCLKBhfR5Tp5G8udyGFs=
X-Received: by 2002:a9d:6307:: with SMTP id q7mr6225149otk.46.1570682174850;
 Wed, 09 Oct 2019 21:36:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAJACTufSmSphvg4-RDR65KOSWzZsL=3b8mn_yRxSE-YtvDhMAg@mail.gmail.com>
 <alpine.DEB.2.11.1909291528200.5147@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1909291528200.5147@piezo.novalocal>
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Thu, 10 Oct 2019 12:36:03 +0800
Message-ID: <CAJACTuf+_VC=zJxbNP5Au3VUTqSu=jPffRgOjPyQvaoXStLmFg@mail.gmail.com>
Subject: Re: Why BlueRocksDirectory::Fsync only sync metadata?
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

> My recollection is that rocksdb is always flushing, correct.  There are
> conveniently only a handful of writers in rocksdb, the main ones being log
> files and sst files.
>
> We could probably put an assertion in fsync() so ensure that the
> FileWriter buffer is empty and flushed...?

Thanks for your reply, sage:-) I will do that:-)

By the way, I've got another question here:
       It seems that BlueStore tries to provide some kind of atomic
I/O mechanism in which data and metadata are either both modified or
both untouched. To accomplish this, for modifications whose size is
larger than prefer_defer_size, BlueStore will allocate new space for
the modifications and release the old storage space. I think, in the
long run, a initially contiguous stored file in bluestore could become
scattered if there have been many random modifications to that file.
Actually, this is what we are experiencing in our test clusters. The
consequence is that after some period of random modification, the
sequential read performance of that file is significantly degraded.
Should we make this atomic I/O mechanism optional? It seems that most
hard disk only make sure that a sector is never half-modified, for
which, I think, the deferred I/O is enough. Am I right? Thanks:-)
