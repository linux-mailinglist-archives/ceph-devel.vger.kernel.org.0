Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62A57D4AB
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 06:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfHAEwZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 00:52:25 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42879 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbfHAEwZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Aug 2019 00:52:25 -0400
Received: by mail-ot1-f65.google.com with SMTP id l15so72809428otn.9
        for <ceph-devel@vger.kernel.org>; Wed, 31 Jul 2019 21:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=42Qot4pZFtSO8cvhi6F6KtjW7oWWEFSIdC/xGCrW2mY=;
        b=BH74N0bHTnWhkTcITDLu6DSiiNwag3YC9duNZYtV1DZWoHMYJbboWjgwxy/MaQcZF7
         RvkjzHwmfxgGond8UfTwofTO6pOz5jpOhZ+tHZsw8X7mdSRN92uQHmTPnNtI9r7VpB8S
         aL5g4ZimPvBVsPUf/+74HlLPxRavE4OIBy/EhRgedPLV370Hj6gfUcz8HMefv7xSdPwx
         y1nlxi/8ywduT6yGqvV8DPOsWsKHxEx/qCGeYvo0Q02cK62C/+1VPmGLls47DYWgeSYv
         yM4dEDbk5t2xkyJpxQUSlqS1W1afHFg6BYrlYfAknGHf42mjwWWXHhfq7hpEs2RDnu7B
         c7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=42Qot4pZFtSO8cvhi6F6KtjW7oWWEFSIdC/xGCrW2mY=;
        b=oM/nfPOHueeueHx2QHxijZu5SShTHe+8CVuOKc+NnfP1VzAF8PhU+BwgLi/XY6MIMj
         4iFc3KAFpkwHGHWvd6Q2+0NuBxxI5w23mzXNk5kqkgYRMcjBOmZVGpVyho2805yt/uAn
         /FP9CLqYYCdR3jy7ZVB45Onl1cPLFmRnef2RoM80gSc7LSSG/HNkWj5ViZGeZa+Y4wYW
         miLhOnIyBRKRKfCIxQTKu2HkOcwyehrGCy2O0loAM3z0zikeIsur/XIXkjVssHjrQIqp
         mdXfIRQkaKJkNWF44G7jclqe8R3mDNjC4iN3shjo0s0i3qUuiXDJmBu8Lc3Am/KSXmbM
         Ak7g==
X-Gm-Message-State: APjAAAWtjd5I2p80SQKq7b+Q5a24EIZqFWFnoFW5nvPAIpNdjPOqbfSh
        5JHyI3i7LJLSsBUq0GbSlPW2Pla4BQPX2oqT3Xc=
X-Google-Smtp-Source: APXvYqyqcGOblh++V/5IxEdd8462JtZmBI0CySBTOhBkHAOt8Pt5PNTFa5ITi5ajdbWcPSNtRjc22id9z4b176S9QP0=
X-Received: by 2002:a05:6830:1319:: with SMTP id p25mr65081683otq.224.1564635144266;
 Wed, 31 Jul 2019 21:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAKQB+fuXv+Q9uPg35GmOmHF=+s1Z9+pFcy05ByfDYEL=LYkpPg@mail.gmail.com>
In-Reply-To: <CAKQB+fuXv+Q9uPg35GmOmHF=+s1Z9+pFcy05ByfDYEL=LYkpPg@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Thu, 1 Aug 2019 12:52:10 +0800
Message-ID: <CAKQB+ftqCjBrXt2f28G-VarQD_5V0tAqrbQs3rf5hbs74AH7-Q@mail.gmail.com>
Subject: Re: ceph-mgr: failed to retrieve mon information and exception shows
To:     branto@redhat.com, Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

It turns out to be a known issue which has been fixed since Ceph
v13.2.5, https://tracker.ceph.com/issues/38109.
We will cherry-pick it and check whether it works or not in our
environment, thanks :)

- Jerry

On Tue, 30 Jul 2019 at 18:14, Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> Hi,
>
> We setup a 3 node cluster (v13.2.4) with 3 MON running and encountered
> a strange issue that mon metadata cannot not be retrieved from the
> restful API mon endpoint but the "ceph mon metadata" command shows
> correctly.  Under such condition, a exception shows as below when
> accessing the mon endpoint.
>
> <title>500 Internal Server Error</title>
> <h1>Internal Server Error</h1>
> <p>The server encountered an internal error and was unable to complete
> your request.  Either the server is overloaded or there is an error in
> the application.</p>
>
> 2019-07-30 17:28:22.539 7fd52a2ef700 -1 mgr get_metadata_python
> Requested missing service mon.Host3
> 2019-07-30 17:28:22.550 7fd52a2ef700  0 mgr[restful] Traceback (most
> recent call last):
>   File "/usr/lib/python2.7/site-packages/pecan/core.py", line 570, in __call__
>     self.handle_request(req, resp)
>   File "/usr/lib/python2.7/site-packages/pecan/core.py", line 508, in
> handle_request
>     result = controller(*args, **kwargs)
>   File "/usr/lib64/ceph/mgr/restful/decorators.py", line 35, in decorated
>     return f(*args, **kwargs)
>   File "/usr/lib64/ceph/mgr/restful/api/mon.py", line 39, in get
>     return context.instance.get_mons()
>   File "/usr/lib64/ceph/mgr/restful/module.py", line 500, in get_mons
>     mon['server'] = self.get_metadata("mon", mon['name'])['hostname']
> TypeError: 'NoneType' object has no attribute '__getitem__'
>
>
> Also, lots of "unhandled message" spams the syslog of active MGR (on Host2):
>
> 2019-07-30 17:28:22.936 7fd52caf4700  0 ms_deliver_dispatch: unhandled
> message 0x55e44f783800 mgrreport(mon.Host3 +53-0 packed 798) v6 from
> mon.? 192.168.2.118:0/612
> 2019-07-30 17:28:23.447 7fd52caf4700  0 ms_deliver_dispatch: unhandled
> message 0x55e44f54d200 mgrreport(mon.Host1 +53-0 packed 798) v6 from
> mon.2 192.168.2.202:0/1967658
>
>
> After raising the debug_mgr from 1/5 to 20, it seems that the there is
> no MON metadata recorded in the DaemonState so that any further update
> are ignored.
>
> 2019-07-30 18:04:50.784 7fd52caf4700  4 mgr.server handle_open from
> 0x55e44de6aa00  mon,Host1
> 2019-07-30 18:04:50.786 7fd52caf4700  4 mgr.server handle_report from
> 0x55e44de6aa00 mon,Host1
> 2019-07-30 18:04:50.786 7fd52caf4700  5 mgr.server handle_report
> rejecting report from mon,Host1, since we do not have its metadata
> now.
> 2019-07-30 18:04:50.786 7fd52caf4700 10 mgr.server handle_report
> unregistering osd.-1  session 0x55e44d219ba0 con 0x55e44de6aa00
> 2019-07-30 18:04:50.786 7fd52caf4700  0 ms_deliver_dispatch: unhandled
> message 0x55e4509b4600 mgrreport(mon.Host1 +53-0 packed 798) v6 from
> mon.2 192.168.2.202:0/1967658
>
> I tried to restart the MON and MGR on Host1 but the "unhandled
> message" logs still keep showning on the active MGR.  Is there any
> idea to fix or to remove the "unhandled message"?  Is it related to
> the inconsistent mon metadata issue?  Thanks.
>
> - Jerry
