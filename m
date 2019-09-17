Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32718B4F10
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Sep 2019 15:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfIQNYZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Sep 2019 09:24:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43155 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727042AbfIQNYZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:24:25 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 09:24:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1568726664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UJOTs0Nv/ujxu+OUGu6PWrPXYAcTowuCEjWD9lxQpeE=;
        b=HRpWmdHJ+x3TKtUo4fOF8Vk87K3he/3IsKRo7mlLzdDeNBttfsziJH/MSnHlUKl7TxETUH
        uFE0aP3fCCkxmAiTbR+xAmK6USHDluvxROYsqUKB8NPDGvdSyo45/NPPrU7RG6gGbH3QSE
        7zryp3cR/LQ6vqZLTtApN6sRnA76BSw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-LWUB2LH5PJ6E-WBONLYIPQ-1; Tue, 17 Sep 2019 09:14:56 -0400
Received: by mail-qk1-f197.google.com with SMTP id r141so4117315qke.7
        for <ceph-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=UJOTs0Nv/ujxu+OUGu6PWrPXYAcTowuCEjWD9lxQpeE=;
        b=PrLuMsQM7v8FQSpr6Y9dkQjYpYW6X0/PQ4U9h4+46e8kKNuPIU4qsKVYZ1vmNZpu1o
         gOMuyvFn9jAGMNTpz/q6/EVf2jlWRdwc2Uf0slJSH3o8Xfb02nTne0PDsdiOK7qp3zct
         AEWW35sUmGK2jgxKwccj3+XnI/zhdBG3GaK1hCpp1bKUkaPb09f1NnlPDJM8X4d9RSe4
         ZZbVyFQK8BHSwbWL9Ta3pc9aw3gQUvsgIGfmNeBdcWe/QHZgheFFZFAM+8A0ldd8g/6y
         p9y1o3adnpgABfxGBVJvceYIwA0fVGocnQ8hNzqXS8uxXctRIFnWdALFhwIgnvyjttxG
         /UDQ==
X-Gm-Message-State: APjAAAWMy6xfLVXbzAWU1P5M2C3+HElvSoiBVeczRbvslZ5DE1BNa7dm
        pL/QL6dP9O6PanZVZgN/Oih7V031rv0QnZjoIasTZGyRo14sYbC+xnV0fETXp2ABSOSVzdCWx+6
        piEVxOsuQwI+nJyJLd9Cj6CNXAyQ8p1cuxcOHnQ==
X-Received: by 2002:a37:6747:: with SMTP id b68mr3610570qkc.155.1568726095514;
        Tue, 17 Sep 2019 06:14:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwnBQj9WdJifZMLasLPSEA0agSsWQVfE085x6v7A+qgxKpwK01K6ObwN0S+mSOuMePDFlm1ksaEp7hFg6qDBqM=
X-Received: by 2002:a37:6747:: with SMTP id b68mr3610544qkc.155.1568726095298;
 Tue, 17 Sep 2019 06:14:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAC-Np1zTk1G-LF3eJiqzSF8SS=h=Jrr261C4vHdgmmwcqhUeXQ@mail.gmail.com>
In-Reply-To: <CAC-Np1zTk1G-LF3eJiqzSF8SS=h=Jrr261C4vHdgmmwcqhUeXQ@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Tue, 17 Sep 2019 09:14:43 -0400
Message-ID: <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com>
Subject: Re: download.ceph.com repository changes
To:     "ceph-maintainers@ceph.com" <ceph-maintainers@ceph.com>,
        ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
X-MC-Unique: LWUB2LH5PJ6E-WBONLYIPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Reviving this old thread.

I still think this is something we should consider as users still
experience problems:

* Impossible to 'pin' to a version. User installs 14.2.0 and 4 months
later they add other nodes but version moved to 14.2.2
* Impossible to use a version that is not what the latest is (e.g. if
someone doesn't need the release from Monday, but wants the one from 6
months ago), similar to the above
* When a release is underway, the repository breaks because syncing
packages takes hours. The operation is not atomic.
* It is not currently possible to "remove" a bad release, in the past,
this means cutting a new release as soon as possible, which can take
days

The latest issue (my fault!) was to cut a release and get the packages
out without communicating with the release manager, which caused users
to note there is a new version *as soon as it was up* vs, a
process that could've not touched the 'latest' url until the
announcement goes out.

If you have been affected by any of these issues (or others I didn't
come up with), please let us know in this thread so that we can find
some common ground and try to improve the process.

Thanks!

On Tue, Jul 24, 2018 at 10:38 AM Alfredo Deza <adeza@redhat.com> wrote:
>
> Hi all,
>
> After the 12.2.6 release went out, we've been thinking on better ways
> to remove a version from our repositories to prevent users from
> upgrading/installing a known bad release.
>
> The way our repos are structured today means every single version of
> the release is included in the repository. That is, for Luminous,
> every 12.x.x version of the binaries is in the same repo. This is true
> for both RPM and DEB repositories.
>
> However, the DEB repos don't allow pinning to a given version because
> our tooling (namely reprepro) doesn't construct the repositories in a
> way that this is allowed. For RPM repos this is fine, and version
> pinning works.
>
> To remove a bad version we have to proposals (and would like to hear
> ideas on other possibilities), one that would involve symlinks and the
> other one which purges the known bad version from our repos.
>
> *Symlinking*
> When releasing we would have a "previous" and "latest" symlink that
> would get updated as versions move forward. It would require
> separation of versions at the URL level (all versions would no longer
> be available in one repo).
>
> The URL structure would then look like:
>
>     debian/luminous/12.2.3/
>     debian/luminous/previous/  (points to 12.2.5)
>     debian/luminous/latest/   (points to 12.2.7)
>
> Caveats: the url structure would change from debian-luminous/ to
> prevent breakage, and the versions would be split. For RPMs it would
> mean a regression if someone is used to pinning, for example pinning
> to 12.2.2 wouldn't be possible using the same url.
>
> Pros: Faster release times, less need to move packages around, and
> easier to remove a bad version
>
>
> *Single version removal*
> Our tooling would need to go and remove the known bad version from the
> repository, which would require to rebuild the repository again, so
> that the metadata is updated with the difference in the binaries.
>
> Caveats: time intensive process, almost like cutting a new release
> which takes about a day (and sometimes longer). Error prone since the
> process wouldn't be the same (one off, just when a version needs to be
> removed)
>
> Pros: all urls for download.ceph.com and its structure are kept the same.

