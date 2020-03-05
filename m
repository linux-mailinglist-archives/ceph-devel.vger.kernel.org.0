Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0C2179CED
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 01:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCEApN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 19:45:13 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46820 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgCEApN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 19:45:13 -0500
Received: by mail-il1-f196.google.com with SMTP id e8so3494309ilc.13;
        Wed, 04 Mar 2020 16:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLm76SSXt/8qfqztUMP9aOaFuRUsyFDRwVe348t+6jg=;
        b=iA9cgqgRepVrwDKiu8wG7aSjRLScY5si4vFQk3gCYepgpCXjSyjJyNTvYhRZ9ZunkH
         jPRuk0JjlMsHXmfcWOva+5JnedzeaPTqo/9sSLcYZp6MGkFIV/mv3NGJmjag2B4nWCfP
         4dTbRC9pdwJYd6eJu+SjM3JIM1/a7bxcOxdxoudRG6aE4ZlZD8di0fFpyGiLVs04ynbj
         aLVwGA7eKTNaEYVZRIoiqeZVdIuEEgqGcgBbfdEzBGVBtn2kI7LEUOqEGEJBPlq2pa/s
         NtPQCxOOOuNLHvnbbVfkUGB0P+Bzpzqr1wwd/oAfcuzqdtd3ZbQnbfBFGDogva/hX9A3
         UQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLm76SSXt/8qfqztUMP9aOaFuRUsyFDRwVe348t+6jg=;
        b=Vp+qKnl6q5aGjH0FIQaY0CZ5ZtXhZexZrsiN8hItsvjyYCSbrbFNrEiKnm4M8tS3Kr
         h+7I60ILHN1x1N3A5DDtdPCwCbltaCeCbzR/uPVjJ3siRokt84e8ay8zKEaAX5wv0+Gs
         gFnLLDudYfH4riKlves3uLCygVtfahkHz97gNIwMYBl62I7zGpKlT6Rpa88kumn7IVKO
         jTiaZAFgeEAREt9mRxAXQs16ZqLow63+Fdihf8yVfrn2E2HVmiWqxVXWltstbd6/uRQb
         w9Zzp0X9JCg0dMEAK3IZaKMbKgnM97H15iRId/3JffVJSC/WA7kyTZ4QRY0LfhKbrCA/
         Eang==
X-Gm-Message-State: ANhLgQ3RZ6jHTdOqFhHvTSf95MlNYQ8j+kHNV8EmTXgMnCQGS3XFalNG
        dgkEUbtx3//ZkB+cqcSWD+CEQWjzGEzNFopiG5M5gq7C
X-Google-Smtp-Source: ADFU+vtDk+RvwiAYEKFOTp3UI/Mlg2rH7N8O0tDxo65ym2aRyyBlcMvFgOZ4IxB9D6nIIqKkkiyM0rJYUKZ8A3KCtiI=
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr5067361ilj.0.1583369112677;
 Wed, 04 Mar 2020 16:45:12 -0800 (PST)
MIME-Version: 1.0
References: <1583252499-16078-1-git-send-email-hqjagain@gmail.com> <f09ffef023cfb8740f6a9a289215e53a16bebb2d.camel@kernel.org>
In-Reply-To: <f09ffef023cfb8740f6a9a289215e53a16bebb2d.camel@kernel.org>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Thu, 5 Mar 2020 08:45:01 +0800
Message-ID: <CAJRQjoeOPrJnXruVU-pTCCrkdQFLUF+ZSE1eBKteTpAve6AJBA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/export: remove unused variable 'err'
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 5, 2020 at 4:36 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I think we probably ought to just return ERR_PTR(err) in that case
> instead of discarding it. It looks like today we'll end up returning
> ENOENT when that errors out which doesn't seem right when there is a
> different issue.

I get that, thanks.

>
> --
> Jeff Layton <jlayton@kernel.org>
>
