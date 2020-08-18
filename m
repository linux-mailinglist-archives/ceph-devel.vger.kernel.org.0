Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF16A248F74
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Aug 2020 22:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHRUKd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Aug 2020 16:10:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57566 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgHRUKb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Aug 2020 16:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597781430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wShkIyLXu8CJzYOMGxc9s2TN/9+dHHRotgHNc6b5I/U=;
        b=TlVHoyvsA5sbb4FyYHalNL8A8oBVj/O28XcUAlPQwIw31m5titfvcN1uH9IeSTFvPd4kx/
        ybhqScgz5ArE2GyxohwPw0nQWiYRFnBl3GehX3ChJ+T3+FjoP+GoEc/x23MteCSp3BIkNE
        /Ej6F+dcU7e0eoi9J0f8O6keLPwg65M=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-LSZhESb-PTqyN2abRO84ww-1; Tue, 18 Aug 2020 16:10:29 -0400
X-MC-Unique: LSZhESb-PTqyN2abRO84ww-1
Received: by mail-il1-f198.google.com with SMTP id 65so15105130ilb.12
        for <ceph-devel@vger.kernel.org>; Tue, 18 Aug 2020 13:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wShkIyLXu8CJzYOMGxc9s2TN/9+dHHRotgHNc6b5I/U=;
        b=uD0CoCW9KIlharFk9GIyPYMjcLhqbHNAh3szki+iFLXWRr6b5ujvvCDXC8OnbjyOPb
         kkHRuB7IRM/fA2ZC8kIpug/l+6aiagZ4h+hrKk0OjKILTVbAdBbQAkvG9tGPIJO2cd1U
         uOFGoKOV96afVtJVzZt1qr7d01N5b2zznNXs3F79BV06Ws3+Q+lRbLoo+5VqcMWpSACN
         Z9XyclPdb3gkyKuUEtPVEaKpkkBOC80rl9vWmNMtOOdJkiqcVbW6/QChYiEx8G2ZNeDW
         jyoeA6gAHTQedOBr/dfuRtqL+x97nHxPsTSGSh72HEBNLJ2bfoSuuDI7T167NOT7HUQj
         GSFw==
X-Gm-Message-State: AOAM533kh244SJDgV6vSmBZjrLNakG7HASIIg0FsVWBI6RKPpjKfh+58
        ytL9/+LV4MwC9GuJbQUEAtKirQCx5Sj+4D/mawbclYyDD/iMZNrcMHtghZew127oUby7tNxxl+J
        UHvWHl3e9BvdN00Z+09N3BcPpyMqVjMQU48gGyQ==
X-Received: by 2002:a05:6e02:be4:: with SMTP id d4mr19635357ilu.140.1597781428289;
        Tue, 18 Aug 2020 13:10:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLBDG3d7AspUnfNNN6RHZZnrhQhqY57ltUCbG2yI+ymkfrz5JI3UyWYzlX1cW0BFV15NGWA2yFPcBsHdQQXLU=
X-Received: by 2002:a05:6e02:be4:: with SMTP id d4mr19635342ilu.140.1597781428076;
 Tue, 18 Aug 2020 13:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200818115317.104579-1-xiubli@redhat.com> <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
In-Reply-To: <7b1e716346aee082cd1ff426faf6b9bff0276ae0.camel@kernel.org>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 18 Aug 2020 13:10:01 -0700
Message-ID: <CA+2bHPZoHhaEBKBKGiR6=Ui7NYnLyT-fMUYHvCcXtT2-oWXRdg@mail.gmail.com>
Subject: Re: [PATCH] ceph: add dirs/files' opened/opening metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 18, 2020 at 1:05 PM Jeff Layton <jlayton@kernel.org> wrote:
> Bear in mind that if the same file has been opened several times, then
> you'll get an increment for each.

Having an open file count (even for the same inode) and a count of
inodes opened sounds useful to me. The latter would require some kind
of refcounting for each inode? Maybe that's too expensive though.

> Would it potentially be more useful to report the number of inodes that
> have open file descriptions associated with them? It's hard for me to
> know as I'm not clear on the intended use-case for this.

Use-case is more information available via `fs top`.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

