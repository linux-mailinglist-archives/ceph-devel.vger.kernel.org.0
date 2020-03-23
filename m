Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FE18EEE4
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 05:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgCWEeV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 00:34:21 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:45557 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgCWEeV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 Mar 2020 00:34:21 -0400
Received: by mail-qt1-f170.google.com with SMTP id t17so506006qtn.12
        for <ceph-devel@vger.kernel.org>; Sun, 22 Mar 2020 21:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DWkZ2TVc24x98jxu7TzYFjjes0wpeTX1lUJrSu7LONo=;
        b=UJcOZ08fCQ1VJgqeo0fFoAy/jacpvliPzc4ReMy+oIcLs9cGpmYqYoWGwecuR263v2
         yKhIzuI5RcWHeAvwlV8nwoDcn5PCQFi5hL7zsFiL6Y8YEb4VOraZ5XURQFyfLiICzHMP
         3gPGMEs+wz8C7DuKoPGlKMqjubzZJqsG4vad/VfSo6PpXzKIP9/9SPjjJwXNlYu7zpct
         Dt+3w8TyxW9/yvd4i6wqDiRsTz8Mjy6VdImO0dvACzLR2loRyfOARJTmDUYVBgHu6YrU
         2A0ep9fu00XM8+yHh4DCLn8UcXvugjf3ev5PHmX/+PyFBZipLIjjCyLCS8olUhsnFUXr
         BMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWkZ2TVc24x98jxu7TzYFjjes0wpeTX1lUJrSu7LONo=;
        b=s59L+t+szn/uWeaSzgZv1hXdBFbi2xVVoIgR+iVF0D2RNq22b82TCBHEF1nl0T2ii3
         Oru/zqSJfhnUoZwxmYPNoO0W9qViNjBUI7UPYAhlqkLRyDn1QUvKg8ldWiRb9BO9zUXa
         O016KAJUj7JYm6zboz0s+sCBHEROKHL8FRcfEvumSofy6halR2OoV7fNr9z2okBMlfex
         jQK+jkogn/GYh6sEAGtSrOf8ZBf3iPiR8a4xb+PI6/jADHopYAyt3VhnekESXMwZLTz9
         dVREVJuzMDFw32pn4xd8vCg07XyHendMQToMfaBGpDv9iA+ILFQDbcwoPOU2LWyjlfuD
         ElfA==
X-Gm-Message-State: ANhLgQ0WTT9bGLHs4hldT0NZUm46Ut/CvrIaYJiVgOpXxbJfOFBOTKVd
        YZh8iOuIKDbsUvqO+XYSPZYVYq4/6TvvfP/s7tX94Uob5MM=
X-Google-Smtp-Source: ADFU+vteP3g8C5XKyclAg9k9xF6B9WGyRWbPkHmczmjslzrE6pYsDArylOc3tKypY5V5txTREs07nItvoaYUvYMK47s=
X-Received: by 2002:aed:3461:: with SMTP id w88mr19718052qtd.143.1584938060309;
 Sun, 22 Mar 2020 21:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAMWWNq-8H8JJsPdL1JC9pOKMQY9LawZDRxfKa7Ag8MWGJbBY5A@mail.gmail.com>
In-Reply-To: <CAMWWNq-8H8JJsPdL1JC9pOKMQY9LawZDRxfKa7Ag8MWGJbBY5A@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 23 Mar 2020 12:34:08 +0800
Message-ID: <CAAM7YAnSxY8QkZWPLT=mDjjf4PVNd=vsi3zb3DEKKhEdivFXVA@mail.gmail.com>
Subject: Re: mds: where is mdr->slave_commit called?
To:     Xinying Song <songxinying.ftd@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Mar 22, 2020 at 3:40 PM Xinying Song <songxinying.ftd@gmail.com> wrote:
>
> Hi, everyone:
> Could anybody give some tips about how `mdr->slave_commit` is called?
>
> As for `link_remote()`, steps are as follows:
> 1. master mds sends OP_(UN)LINKPREP to salve mds.
> 2. slave mds replys OP_LINKPREPACK to master mds after its journal has
> been flushed.
> 3. master mds continues to process the client request.
>
> I only find out there is a chance in MDCache::request_finish() that
> `mdr->slave_commit` will be called. However, after a successful
> journal flush, slave mds only sends an ACK to master mds and bypasses
> MDCache::request_finish().
> So when or where is `mdr->slave_commit` called?
>
> Thanks!

master calls MDCache::request_finsih(),
MDCache::request_drop_foreign_locks() sends
MMDSSlaveRequest::OP_FINISH message to slaves.  slaves call
MDCache::request_finsih() when receiving the message.
